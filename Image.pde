class Image{
  HashMap<String, PImage> image = new HashMap<String, PImage>();
  
  Image(String type){
    String absolutePath = dataPath("image");
    switch (type){
      case "player":
        String playerFileName[];
        String playerPath = absolutePath + "\\player";
        playerFileName = getFileName(playerPath);
        for(String name : playerFileName)
          this.image.put(name.substring(0, name.indexOf(".")), loadImage(playerPath + "\\" + name));
        break;
        
      case "item":
        String itemFileName[];
        String itemPath = absolutePath + "\\item";
        itemFileName = getFileName(itemPath);
        for(String name : itemFileName)
          this.image.put(name.substring(0, name.indexOf(".")), loadImage(itemPath + "\\" + name));
        break;
        
      case "enemy":
        String enemyFileName[];
        String enemyPath = absolutePath + "\\enemy";
        enemyFileName = getFileName(enemyPath);
        for(String name : enemyFileName)
          this.image.put(name.substring(0, name.indexOf(".")), loadImage(enemyPath + "\\" + name));
        break;
        
      case "background":
        String backgroundFileName[];
        String backgroundPath = absolutePath + "\\background";
        backgroundFileName = getFileName(backgroundPath);
        for(String name : backgroundFileName)
          this.image.put(name.substring(0, name.indexOf(".")), loadImage(backgroundPath + "\\" + name));
        break;
        
      case "status":
        String statusFileName[];
        String statusPath = absolutePath + "\\status";
        statusFileName = getFileName(statusPath);
        for(String name : statusFileName)
          this.image.put(name.substring(0, name.indexOf(".")), loadImage(statusPath + "\\" + name));
        break;
        
      case "all":
        String allFileName[];
        String allPath[] = {absolutePath + "\\player", absolutePath + "\\item", absolutePath + "\\enemy", absolutePath + "\\background", absolutePath + "\\status"};
        for(String path : allPath){
          allFileName = getFileName(path);
          for(String name : allFileName)
            this.image.put(name.substring(0, name.indexOf(".")), loadImage(path + "\\" + name));
        }
        break;
    }
  }
  
  //String[] getFileName(String fileDirectory){
  //  File directory1 = new File(fileDirectory);
  //  String[] file = directory1.list();
  //  return file;
  //}
  
  PImage getImage(String name, int widthSize, int heightSize){
    PImage image = this.image.get(name);
    image.resize(widthSize, heightSize);
    return image;
  }
}
