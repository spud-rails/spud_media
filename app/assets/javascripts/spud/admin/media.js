//= require jcrop/js/jquery.Jcrop
//= require_self

Spud = (typeof(Spud) == 'undefined') ? {} : Spud;
Spud.Admin = (typeof(Spud.Admin) == 'undefined') ? {} : Spud.Admin;

Spud.Admin.Media = new function(){
  
  var self = this;

  this.new = function(){

  };

  this.selectedFile = function(){

  };

  var cropimage;
  var cropcontainer;
  var croptarget;
  var cropscale;
  var originalWidth;
  var originalHeight;
  var cropartbox;
  var jcrop;

  this.edit = function(){

    cropscale = parseFloat($('#spud_media_crop_s').val());
    cropimage = $('#spud_media_cropper_image');
    cropcontainer = $('#spud_media_cropper_jcrop_container');
    cropartbox = $('#spud_media_cropper');

    // get the original dimensions before scaling the image down
    originalWidth = cropimage.width();
    originalHeight = cropimage.height();

    self.resizeAndCenter(cropscale);

    $('body').on('change', '#spud_media_crop_s', self.changedMediaCropScale);
    $('body').on('change', '#spud_media_crop_x, #spud_media_crop_y, #spud_media_crop_w, #spud_media_crop_h', self.changedMediaCropDimensions);
  };

  this.resizeAndCenter = function(percent){

    // destroy the jcrop object and reinit. set the proper scale.
    if(jcrop){
      jcrop.destroy();
    }

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

    // update height of artbox
    cropartbox.height(_height);

    // using the outer contiainer, center the cropper in the artboard
    var _left = (900 - _width) / 2;
    //var _top = (600 - _height) / 2;
    var _top = 0;
    cropcontainer.css({
      left:_left,
      top:_top
    });
  };

  this.updateCropCoordinates = function(c){
    $('#spud_media_crop_x').val(Math.floor(c.x));
    $('#spud_media_crop_y').val(Math.floor(c.y));
    $('#spud_media_crop_w').val(Math.floor(c.w));
    $('#spud_media_crop_h').val(Math.floor(c.h));
  };

  this.changedMediaCropScale = function(e){
    var val = $(this).val();
    var percent = parseInt(val);
    if(!percent || percent > 100){
      $(this).val(cropscale);
    }
    else{
      cropscale = percent;
      self.resizeAndCenter(percent); 
    }
  };

  this.changedMediaCropDimensions = function(e){
    var selection = self.getSelectFields();
    if(selection){
      jcrop.setSelect(selection);
    }
  };

  this.getSelectFields = function(){
    var x = parseInt($('#spud_media_crop_x').val());
    var y = parseInt($('#spud_media_crop_y').val());
    var w = parseInt($('#spud_media_crop_w').val());
    var h = parseInt($('#spud_media_crop_h').val());
    var x2 = x + w;
    var y2 = y + h;
    if(isNaN(x) || isNaN(w) || isNaN(x2) || isNaN(y2)){
      return false;
    }
    else{
      return [x, y, x2, y2];
    }
  }
};