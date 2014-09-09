function pass_video_src(){
  var option = document.getElementById("video_selector").value;
  console.log("video option" + option);
  if(option == 0){
    document.getElementById("video").src = "//player.vimeo.com/video/86328631";  
  }
  if (option == 1) {
    document.getElementById("video").src = "//player.vimeo.com/video/31447830";  
  }
  if (option == 2) {
    document.getElementById("video").src = "//player.vimeo.com/video/66549713";  
  }
}