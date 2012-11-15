//= require jcrop/js/jquery.Jcrop
//= require spud/admin/media/plugin
//= require spud/admin/media/picker
//= require_self

spud.admin.media = new function(){

  var self = this;
  var cropimage;
  var cropcontainer;
  var croptarget;
  var cropscale;
  var maxcropscale;
  var cropscaleincrement;
  var originalWidth;
  var originalHeight;
  var cropartbox;
  var jcrop;

  this.edit = function(){
    cropimage = $('#spud_media_cropper_image');
    // IE8 isn't handling the image load event properly, so...
    setTimeout(function(){
      if(cropimage[0].complete){
        self.initializeEditor();
      }
      else{
        self.edit();
      }
    }, 50);
  };

  this.initializeEditor = function(){

    // cache some selectors
    cropcontainer = $('#spud_media_cropper_jcrop_container');
    cropartbox = $('#spud_media_cropper');

    // get the original dimensions before scaling the image down
    originalWidth = cropimage.width();
    originalHeight = cropimage.height();

    // the max width is 900px (at least until the UI can handle more than that)
    if(originalWidth > 900){
      maxcropscale = Math.floor(900 / originalWidth * 100);
    }
    else{
      maxcropscale = 100;
    }
    cropscaleincrement = Math.ceil(3.0 * (maxcropscale / 100));

    // scale down the original if necessary
    cropscale = parseInt($('#spud_media_crop_s').val(), 10);
    if(cropscale > maxcropscale){
      $('#spud_media_crop_s').val(maxcropscale);
      cropscale = maxcropscale;
    }

    // if this is a new image, width and hight will be null. set some starter values.
    if(!$('#spud_media_crop_w').val()){
      $('#spud_media_crop_w').val(originalWidth * (maxcropscale / 100));
      $('#spud_media_crop_h').val(originalHeight * (maxcropscale / 100));
    }

    // update height of artbox to match height of scaled image
    cropartbox.height(originalHeight * (maxcropscale / 100));

    self.resizeAndCenter(cropscale);

    $('body').on('change', '#spud_media_crop_s', self.changedMediaCropScale);
    $('body').on('click', '#spud_media_cropper_resize_up, #spud_media_cropper_resize_down', self.incrementMediaCropScale);
    $('body').on('change', '#spud_media_crop_x, #spud_media_crop_y, #spud_media_crop_w, #spud_media_crop_h', self.changedMediaCropDimensions);
    $('body').on('keypress', 'form input[type=text]', self.preventSubmitOnEnterKey);
  };

  this.resizeAndCenter = function(percent){

    // destroy the jcrop object if it exists already
    if(jcrop){
      jcrop.destroy();
    }

    // initialize jcrop. snap to pre-existing selection if one exists.
    var _width = Math.min(900, (originalWidth * (percent / 100)));
    var _height = originalHeight * (_width / originalWidth);
    cropimage.Jcrop({
        boxWidth:_width,
        boxHeight:_height,
        onChange:self.updateCropCoordinates,
        onSelect:self.updateCropCoordinates,
        setSelect:self.getSelectFields()
      },
      function(){
        jcrop = this;
      }
    );

    // using the outer container, center the jcrop object in the artboard
    var _left = (900 - _width) / 2;
    var _top = (cropartbox.height() - _height) / 6;
    cropcontainer.css({
      left:_left,
      top:_top
    });
  };

  this.updateCropCoordinates = function(c){
    $('#spud_media_crop_x').val(Math.floor(c.x * (cropscale / 100)));
    $('#spud_media_crop_y').val(Math.floor(c.y * (cropscale / 100)));
    $('#spud_media_crop_w').val(Math.floor(c.w * (cropscale / 100)));
    $('#spud_media_crop_h').val(Math.floor(c.h * (cropscale / 100)));
  };

  this.changedMediaCropScale = function(e){
    var val = $(this).val();
    var percent = parseInt(val, 10);
    if(!percent || percent > maxcropscale){
      $(this).val(maxcropscale);
    }
    else{
      $(this).val(percent);
      cropscale = percent;
      self.resizeAndCenter(percent);
    }
  };

  this.incrementMediaCropScale = function(e){
    var id = $(this).attr('id');
    if(id == 'spud_media_cropper_resize_up'){
      cropscale = Math.min(maxcropscale, cropscale+cropscaleincrement);
    }
    else{
      cropscale = Math.max(0, cropscale-cropscaleincrement);
    }
    $('#spud_media_crop_s').val(cropscale);
    self.resizeAndCenter(cropscale);
    return false;
  };

  this.changedMediaCropDimensions = function(e){
    var selection = self.getSelectFields();
    if(selection){
      jcrop.setSelect(selection);
    }
  };

  this.getSelectFields = function(){
    var x = parseInt($('#spud_media_crop_x').val(), 10);
    var y = parseInt($('#spud_media_crop_y').val(), 10);
    var w = parseInt($('#spud_media_crop_w').val(), 10);
    var h = parseInt($('#spud_media_crop_h').val(), 10);
    var x2 = x + w;
    var y2 = y + h;
    if(isNaN(x) || isNaN(w) || isNaN(x2) || isNaN(y2)){
      return false;
    }
    else{
      return [x * (100 / cropscale), y * (100 / cropscale), x2 * (100 / cropscale), y2 * (100 / cropscale)];
    }
  };

  this.preventSubmitOnEnterKey = function(e){
    if(e.keyCode == 13) {
      e.preventDefault();
      // need to prevent the form submit, but still fire the value change events
      if($(this).attr('id') == 'spud_media_crop_s'){
        self.changedMediaCropScale.apply(this, [e]);
      }
      else{
        self.changedMediaCropDimensions(e);
      }
      return false;
    }
  };
};