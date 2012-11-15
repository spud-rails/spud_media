spud.admin.mediapicker = new function(){
  
  var self = this;
  var supportsHtml5Upload = false;
  var selectedFile = {};

  self.init = function(){
    if(typeof(FormData) != 'undefined'){
      supportsHtml5Upload = true;
    }
    $('.spud_media_picker_tab').on('click', self.clickedTab);
    $('.spud_media_picker_upload_form').on('submit', self.submittedUpload);
    $('.spud_media_picker_list').on('click', '.spud_media_picker_item', self.clickedListItem);
    $('.spud_media_picker_button_cancel').on('click', self.clickedCancel);
    $('.spud_media_picker_button_use_selected').on('click', self.clickedUseSelected);
    $('.spud_media_picker_button_insert').on('click', self.clickedInsert);
    $('.spud_media_picker_item').first().click();
    $('.spud_media_picker_tabs a').first().click();
    $('.spud_media_picker_tab_advanced').on('spud_media_picker_tab_activated', self.activatedAdvancedTab);
    $('.spud_media_picker_option_dimensions').on('blur', 'input', self.dimensionsChanged);
  };

  self.clickedTab = function(e){
    e.preventDefault();
    self.goToTab($(this).attr('href'));
  };

  self.goToTab = function(tabName){
    $('.spud_media_picker_tab_active').removeClass('spud_media_picker_tab_active');
    $('a[href="'+tabName+'"]').addClass('spud_media_picker_tab_active');
    var selector = tabName.replace('#', '.');
    $('.spud_media_picker_tab_body').hide();
    $(selector).show();
    $(selector).trigger('spud_media_picker_tab_activated');
  };

  self.clickedListItem = function(){
    $('.spud_media_picker_item_selected').removeClass('spud_media_picker_item_selected');
    var element = $(this);
    element.addClass('spud_media_picker_item_selected');
    $('.spud_media_picker_details_thumb').attr('src', element.find('img').attr('src'));
    $('.spud_media_picker_details_name').text(element.attr('data-name'));
    $('.spud_media_picker_details_size').text(element.attr('data-size'));
    $('.spud_media_picker_details_lastmod').text(element.attr('data-lastmod'));
    $('.spud_media_picker_details_protected').text(element.attr('data-protected'));
    $('.spud_media_picker_details').show();
  };
  
  self.clickedCancel = function(e){
    e.preventDefault();
    tinyMCEPopup.close();
  };
  
  self.clickedUseSelected = function(e){
    e.preventDefault();
    self.goToTab('#spud_media_picker_tab_advanced');
  };
  
  self.submittedUpload = function(e){
    if(!$('#spud_media_attachment').val()){
      window.alert("Please select a file.");
      return false;
    }

    if(supportsHtml5Upload){
      e.preventDefault();

      // create html5 form object
      var fd = new FormData();
      var form = $(this);
      var file = form.find('#spud_media_attachment')[0].files[0];
      fd.append('_method', form.find('[name=_method]').val());
      fd.append('authenticity_token', form.find('[name=authenticity_token]').val());
      fd.append('spud_media[attachment]', file);

      // upload via xhr
      var xhr = new XMLHttpRequest();
      xhr.upload.addEventListener('progress', self.onFileUploadProgress);
      xhr.addEventListener('load', self.onFileUploadComplete);
      xhr.addEventListener('error', self.onFileUploadError);
      xhr.addEventListener('abort', self.onFileUploadAbort);
      xhr.open('POST', form.attr('action'));
      xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
      xhr.send(fd);

      $('.spud_media_picker_upload_progress').show();
    }
  };

  this.onFileUploadProgress = function(e){
    var percent = Math.round(e.loaded * 100 / e.total);
    var progress = $('.spud_media_picker_upload_progress');
    progress.find('.bar').css({width: percent + '%'});
    if(percent == 100){
      progress.addClass('progress-success');
    }
  };

  this.onFileUploadComplete = function(e){
    var html = e.target.response;
    self.onLegacyUploadComplete(html);
  };

  this.onFileUploadError = function(e){
    window.alert('Whoops! Something has gone wrong.');
    self.resetUploadForm();
  };

  this.onFileUploadAbort = function(e){
    self.resetUploadForm();
  };

  // Non-html5 upload
  this.onLegacyUploadComplete = function(html){
    $('.spud_media_picker_list').prepend(html);
    $('.spud_media_picker_item').first().click();
    self.goToTab('#spud_media_picker_tab_choose');
    self.resetUplaodForm();
  };

  this.resetUploadForm = function(){
    // reset twitter bootstrap "loading" button state
    $('.spud_media_picker_tab_upload_submit').button('reset');
    $('#spud_media_attachment').val('');
    $('.spud_media_picker_upload_progress').hide();
    $('.spud_media_picker_upload_progress .bar').css({width:0});
  };

  this.activatedAdvancedTab = function(){
    var selected = $('.spud_media_picker_item_selected');
    selectedFile = {
      id: selected.attr('data-id'),
      type: selected.attr('data-type'),
      url: selected.attr('data-url'),
      name: selected.attr('data-name'),
      size: selected.attr('data-size'),
      lastmod: selected.attr('data-lastmod'),
      isprotected: selected.attr('data-protected')
    };
    $('input[name="spud_media_picker_option_selected_file"]').val(selectedFile.name);
    $('input[name="spud_media_picker_option_type"]').val(selectedFile.type == 'img' ? 'Image' : 'File');
    if(selectedFile.type == 'img'){
      $('.spud_media_picker_option_target').hide();
      $('.spud_media_picker_option_text').hide();
      $('.spud_media_picker_option_float').show();
      $('.spud_media_picker_option_title').show();
      $('.spud_media_picker_option_dimensions').show();
      self.getOriginalImageDimensions(selectedFile.url);
    }
    else{
      $('.spud_media_picker_option_target').show();
      $('.spud_media_picker_option_text').show();
      $('.spud_media_picker_option_float').hide();
      $('.spud_media_picker_option_title').hide();
      $('.spud_media_picker_option_dimensions').hide();
    }
  };

  var _originalWidth, _originalHeight;
  self.getOriginalImageDimensions = function(url){
    var img = new Image();
    img.onload = function(){
      _originalWidth = img.width;
      _originalHeight = img.height;
      console.log(_originalWidth, _originalHeight);
    };
    img.src = url;
  };

  self.dimensionsChanged = function(e){
    var element = $(this);
    var val = parseInt(element.val(), 10);
    if(isNaN(val)){
      element.val('');
      return;
    }
    var name = element.attr('name');
    if(name == 'spud_media_picker_option_dimension_w'){
      var height = Math.floor((_originalHeight/_originalWidth) * val);
      $('input[name="spud_media_picker_option_dimension_h"]').val(height);
    }
    else{
      var width = Math.ceil((_originalWidth/_originalHeight) * val);
      $('input[name="spud_media_picker_option_dimension_w"]').val(width);
    }
  };

  self.clickedInsert = function(e){
    e.preventDefault();
    if(selectedFile.type == 'img'){
      selectedFile.title = $('input[name="spud_media_picker_option_title"]').val();
      selectedFile.width = parseInt($('input[name="spud_media_picker_option_dimension_w"]').val(), 10);
      selectedFile.height = parseInt($('input[name="spud_media_picker_option_dimension_h"]').val(), 10);
      var float = $('select[name="spud_media_picker_option_float"]').val();
      var style = "";
      if(float){
        style += "float:" + float + ";";
      }
      selectedFile.style = style;
    }
    else{
      selectedFile.target = $('select[name="spud_media_picker_option_target"]').val();
      selectedFile.text = $('input[name="spud_media_picker_option_text"]').val();
    }
    tinyMCEPopup.editor.execCommand('spudMediaInsertSelected', false, selectedFile);
    tinyMCEPopup.close();
  };
};