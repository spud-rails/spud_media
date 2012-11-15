spud.admin.mediapicker = new function(){
  
  var self = this;



  self.init = function(){
    $('.spud_media_picker_tab').on('click', self.clickedTab);
    $('.spud_media_picker_upload_form').on('submit', self.submittedUpload);
    $('.spud_media_picker_item').on('click', self.clickedItem);
    $('.spud_media_picker_button_cancel').on('click', self.clickedCancel);
    $('.spud_media_picker_button_insert').on('click', self.clickedInsert);
    $('.spud_media_picker_item').first().click();
    $('.spud_media_picker_tabs a').first().click();
  };
  
  self.clickedTab = function(e){
    e.preventDefault();
    var element = $(this);
    $('.spud_media_picker_tab_active').removeClass('spud_media_picker_tab_active');
    element.addClass('spud_media_picker_tab_active');
    var selector = element.attr('href').replace('#', '.');
    $('.spud_media_picker_tab_body').hide();
    $(selector).show();
  };
  
  self.clickedItem = function(){
    console.log('click');
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
  
  self.clickedInsert = function(e){
    e.preventDefault();
    var selected = $('.spud_media_picker_item_selected');
    if(selected){
      data = {
        url: selected.attr('data-url'),
        type: selected.attr('data-type')
      };
      tinyMCEPopup.editor.execCommand('spudMediaInsertSelected', false, data);
      tinyMCEPopup.close();
    };
  };
  
  self.submittedUpload = function(e){

  };
};