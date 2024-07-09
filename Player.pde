class Player {
  Image image;
  PImage hiyokoImage;
  PImage hiyokoDamageImage;
  String playerImagePath;
  boolean collision;
  int hitFrame = -120;
  int maxHP;
  int HP;
  int maxHPLimit = 5;
  int imageEdge = 60;

  Player(Image image) {
    this.image = image;
    this.maxHP = 3;
    this.HP = this.maxHP;
    this.hiyokoImage = this.image.getImage("hiyoko", imageEdge, imageEdge);
    this.hiyokoDamageImage = this.image.getImage("hiyoko_damage", imageEdge, imageEdge);
    this.collision = true;
  }
  
  void playerDirection(){
    if(mouseX > pmouseX){
      this.hiyokoImage = this.image.getImage("hiyoko_r", imageEdge, imageEdge);
      this.hiyokoDamageImage = this.image.getImage("hiyoko_damage_r", imageEdge, imageEdge);
    }
    else if(mouseX < pmouseX){
      this.hiyokoImage = this.image.getImage("hiyoko", imageEdge, imageEdge);
      this.hiyokoDamageImage = this.image.getImage("hiyoko_damage", imageEdge, imageEdge);
    }
  }
  
  void showPlayer() {
    playerDirection();
    if(frameCount - hitFrame >= 120 || HP <= 0)
      setImage(this.hiyokoImage, mouseX, mouseY, imageEdge);
    else{
      if(frameCount % 20 < 10){
        setImage(this.hiyokoDamageImage, mouseX, mouseY, imageEdge);
      }
    }
  }
  
  void invincible(){
    hitFrame = frameCount;
    this.collision = false;
  }
  
  void finInvincible(){
    if(frameCount - hitFrame >= 120){
      this.collision = true;
    }
  }
  
  int getHP(){
    return this.HP;
  }
  
  void heal(int heal){
    this.HP += heal;
    if(this.HP > this.maxHP)
      this.HP = maxHP;
  }
  
  void maxHeal(){
    if(this.maxHP < this.maxHPLimit)
      this.maxHP += 1;
    this.HP = maxHP;
  }
  
  int getMaxHP(){
    return this.maxHP;
  }
  
  void hitDamage(){
    this.HP --;
  }
  
  void death(){
    this.HP = 0;
  }
  
  boolean getCollision(){
    return collision;
  }
}
