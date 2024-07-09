class Game {
  int score;
  int highscore;
  String  state;
  int x, y;
  int maxHP;
  PImage scoreImage;
  boolean musicFlag, soundFlag;
  int t[] = new int[7];
  String s[] = new String[11];
  String _s;
  int enemyFrame, ready;
  JSONObject titleImageJSON;
  PFont titleFont = createFont("./font/jackeyfont.ttf", 70);
  PFont font = createFont("./font/jackeyfont.ttf", 50);
  int textSpeed = 7;

  Player hiyoko;
  Sound sound;
  Image image = new Image("all");
  Image playerImage = new Image("player");
  Image itemImage = new Image("item");
  Image enemyImage = new Image("enemy");
  Item item[] = new Item[3];
  Enemy enemy[] = new Enemy[3];


  Game(hiyoko obj) {
    this.highscore = loadHighscore();
    this.titleImageJSON = loadTitleImage();
    this.state = "start";
    this.score = 0;
    this.x = 0;
    this.y = 0;
    this.musicFlag = true;
    this.soundFlag = true;
    this.sound = new Sound(obj);
    this.hiyoko = new Player(this.playerImage);
    for (int i = 0; i<3; i++){
      this.item[i] = new Item(this.itemImage);
      this.enemy[i] = new Enemy(this.itemImage);
    }
    for(int i = 0; i < 6; i++)
      this.t[i] = 0;
    this.s[0] = "げーむおーばー";
    this.s[1] = "もういちど";
    this.s[2] = "たいとる";
    this.s[3] = "これまでのはいすこあ：";
    this.s[4] = "すこあ:";
    this.s[5] = "まだまだひよっこ";
    this.s[6] = "ひよこ　そつぎょう！\nにわとりれべる！";
    this.s[7] = "そのいきおい、\nぺんぎんなみ！";
    this.s[8] = "そのすばやさ、\nふくろうのよう！";
    this.s[9] = "かれいなひこう！\nまさにとんび！";
    this.s[10] = "たかなみの\nどうたいしりょく！";
  }

  void showScore() {
    fill(0);
    textAlign(LEFT);
    text("すこあ："+ this.score, 0, 50);
  }
  
  void saveHighscore(int highscore){
    JSONObject json = new JSONObject();
    json.setInt("Highscore", highscore);
    //json.setString("
    saveJSONObject(json, "./data/save/score.json");
  }
  
  void saveTitleImage(JSONObject json){
    saveJSONObject(json, "./data/save/titleImage.json");
  }
  
  JSONObject loadTitleImage(){
      JSONObject json = new JSONObject();
      if(loadJSONObject("./data/save/titleImage.json") != null)
        json = loadJSONObject("./data/save/titleImage.json");
      else{
        json.setBoolean("hiyoko", true);
        json.setBoolean("chicken", false);
        json.setBoolean("penguin", false);
        json.setBoolean("owl", false);
        json.setBoolean("kite", false);
        json.setBoolean("hawk", false);
        json.setString("nowImage", "hiyoko");
        saveJSONObject(json, "./data/save/titleImage.json");
      }
      return json;
  }
  
  int loadHighscore(){
    JSONObject json = new JSONObject();
    int highscore = 0;
    try{
      json = loadJSONObject("./data/save/score.json");
      highscore = json.getInt("Highscore");
      if(highscore > 999999999)
        highscore = 999999999;
    }catch(NullPointerException e){
      highscore = 0;
    }
    return highscore;
  }

  void showHP() {
    for(int i = 0; i <= this.hiyoko.getMaxHP() - 1; i++){
      if(i >= this.hiyoko.getHP())
        break;
      image(this.image.getImage("HP", 50, 50), i * 50, 50);
    }
    for(int i = 0; i <= this.hiyoko.getMaxHP() -1; i++){
      if(i < this.hiyoko.getHP())
        continue;
      image(this.image.getImage("breakHP", 50, 50), i * 50, 50);
    }
  }

  void itemCollision(int index) {
    if ( abs ( this.item[index].getX() - mouseX ) < 40 && abs ( this.item[index].getY() - mouseY ) < 40 ) {
      this.score += item[index].getPoint();
      this.sound.playSound(item[index].getSoundName(), -10);
      this.hiyoko.heal(this.item[index].getHeal());
      if(this.item[index].getMaxHeal()){
          this.hiyoko.maxHeal();
      }
      this.item[index] = new Item(this.itemImage);
    }
  }
  
  void deleteItem(int index){
    if(this.item[index].deleteTF())
      this.item[index] = new Item(this.itemImage);
  }
  
  void enemyCollision(int index){
    if ( abs ( this.enemy[index].getX() - mouseX ) < 35 && abs ( this.enemy[index].getY() - mouseY ) < 35 && this.hiyoko.getCollision()) {
      if(this.enemy[index].getDamage()){
         this.hiyoko.hitDamage();
      }else if(this.enemy[index].death){
        this.hiyoko.death();
      }
      if(this.hiyoko.getHP() >= 1){
        this.hiyoko.invincible();
        this.sound.playSound("damageA", 0);
        this.sound.playSound("hiyoko_voice", -10);
      }
    }
  }
  
  void deleteEnemy(int index){
    if(this.enemy[index].enemyDelete())
      this.enemy[index] = new Enemy(this.enemyImage);
  }

  void display() {
    //---------------------startMenu----------------------
    switch(this.state){
      case "start":
        if (this.musicFlag) {
          this.musicFlag = false;
          this.sound.loopMusic("startBGM", -20);
        }
        background(0, 0, 90);
        textAlign(CENTER, CENTER);
        textFont(titleFont);
        fill(0);
        text("ひよこたろう", width/2, height/3);
        //fill(0, 100, 100);
        //rect(width/2-115, height/2-30, 220, 70);
        if (mouseX >= width/2 - 115 && mouseX <= width/2+105 && mouseY >= height/2-30 && mouseY <= height/2+50)
          fill(0, 40, 100);
        else
          fill(0);
        textFont(font);
        text("はじめる", width/2, height/2);
        
        //fill(0, 100, 100);
        //rect(width/2-125, height/1.5-30, 235, 70);
        if (mouseX >= width/2 - 125 && mouseX <= width/2+110 && mouseY >= height/1.5-30 && mouseY <= height/1.5+50)
          fill(0, 40, 100);
        else
          fill(0);
        text("あそびかた", width/2, height/1.5);
        
        if (mouseX >= width/2 - 90 && mouseX <= width/2+ 80 && mouseY >= height/1.2-30 && mouseY <= height/1.2+50)
          fill(0, 40, 100);
        else
          fill(0);
        text("やめる", width/2, height/1.2);
        
        fill(0);
        textAlign(LEFT, TOP);
        text("これまでのはいすこあ：" + highscore, 5, 0);
        
        if(this.titleImageJSON.getString("nowImage").equals("hiyoko")){
          scoreImage = this.image.getImage("hiyoko", 250, 250);
        }else if(this.titleImageJSON.getString("nowImage").equals("chicken")){
          scoreImage = this.image.getImage("chicken", 250, 250);
        }else if(this.titleImageJSON.getString("nowImage").equals("penguin")){
          scoreImage = this.image.getImage("penguin", 250, 250);
        }else if(this.titleImageJSON.getString("nowImage").equals("owl")){
          scoreImage = this.image.getImage("owl", 250, 250);
        }else if(this.titleImageJSON.getString("nowImage").equals("kite")){
          scoreImage = this.image.getImage("kite", 250, 250);
        }else if(this.titleImageJSON.getString("nowImage").equals("hawk")){
          scoreImage = this.image.getImage("hawk", 250, 250);
        }
        image(scoreImage, width - 250, height - 250);
        image(this.image.getImage("hiyoko_r", 250, 250), 0, height-250);
        
        hiyoko.showPlayer();
        if (this.x >= width/2 - 115 && this.x <= width/2+105 && this.y >= height/2-30 && this.y <= height/2+50) {
          this.score = 0;
          this.sound.stopMusic();
          this.state = "game";
          this.ready = frameCount;
          this.enemyFrame = frameCount;
          this.x = 0;
          this.y = 0;
          this.musicFlag = true;
          this.hiyoko = new Player(this.playerImage);
          for (int i = 0; i<3; i++){
            this.item[i] = new Item(this.itemImage);
            this.enemy[i] = new Enemy(this.enemyImage);
          }
          for(int i = 0; i < 6; i++)
            this.t[i] = 0;
        }
        
        if (this.x >= width/2 - 125 && this.x <= width/2+110 && this.y >= height/1.5-30 && this.y <= height/1.5+50) {
          this.state = "tutorial1";
          this.x = 0;
          this.y = 0;
        }
        
        if (this.x >= width/2 - 90 && this.x <= width/2+ 80 && this.y >= height/1.2-30 && this.y <= height/1.2+50)
          exit();
          
        if (this.x >= width-250 && this.y >= height-250) {
          this.state = "choiceBird1";
          this.x = 0;
          this.y = 0;
        }
          
        break;
    //------------------------gameScreen------------------------------
      case "game":
        image(this.image.getImage("gameBack", width, height), 0, 0);
        if(frameCount - this.ready >= 60){ 
          if (this.musicFlag) {
            this.musicFlag = false;
            this.sound.loopMusic("gameBGM", -20);
          }
          showScore();
          showHP();
          this.hiyoko.finInvincible();
          int i = 0;
          for (Item item : this.item) {
            item.showItem();
            item.move();
            deleteItem(i);
            itemCollision(i);
            i++;
          }
          int j = 0;
          if(frameCount - this.enemyFrame >= 80)
            for(Enemy enemy : this.enemy){
              enemy.showEnemy();
              enemy.move();
              deleteEnemy(j);
              enemyCollision(j);
              j++;
            }
          if (this.hiyoko.getHP() <= 0) {
            this.sound.stopMusic();
            this.state = "gameover";
            this.x = 0;
            this.y = 0;
            this.musicFlag = true;
          }
        }else{
          textAlign(CENTER, CENTER);
          text("よーい" , width/2, height/2);
          }
        this.hiyoko.showPlayer();
        break;
        
      //---------------------------gameoverMenu-----------------------------
      case "gameover":
        if (this.musicFlag) {
          this.musicFlag = false;
          this.sound.loopMusic("gameoverBGM", -20);
        }
        
        textAlign(CENTER, CENTER);
        
        //gameover
        image(this.image.getImage("gameoverBack", width, height), 0, 0);
        if(frameCount % textSpeed == 0 && t[0] <s[0].length()){
          this.sound.playSound("talk", 30);
          t[0]++;
        }
        text(s[0].substring(0, t[0]), width/2, height/3);
        
        //restart
        //fill(0, 100, 100);
        //rect(width/2-140, height/2-25, 265, 65);
        
        if (mouseX >= width/2 - 140 && mouseX <= width/2+125 && mouseY >= height/2-25 && mouseY <= height/2+40)
          fill(0, 40, 100);
        else
          fill(0, 0, 100);
        if(frameCount % textSpeed == 0 && t[0] >= s[0].length() && t[1] < s[1].length()){
          this.sound.playSound("talk", 30);
          t[1]++;
        }
        text(s[1].substring(0, t[1]), width/2, height/2);
        
        //たいとる
        //fill(0, 100, 100);
        //rect(width/2-115, height/1.5-30, 220, 70);
        if (mouseX >= width/2 - 115 && mouseX <= width/2+105 && mouseY >= height/1.5-30 && mouseY <= height/1.5+40)
          fill(0, 40, 100);
        else
          fill(0, 0, 100);
        if(frameCount % textSpeed == 0 && t[1] >= s[2].length() && t[2] < s[2].length()){
          this.sound.playSound("talk", 30);
          t[2]++;
        }
        textAlign(CENTER, CENTER);
        text(s[2].substring(0, t[2]), width/2, height/1.5);
        
        //highscore
        fill(0, 0, 100);
        textAlign(LEFT, TOP);
        String _highscore = s[3] + String.valueOf(this.highscore);
        if(frameCount % textSpeed == 0 && t[2] >= s[2].length() && t[3] < _highscore.length()){
          this.sound.playSound("talk", 30);
          t[3]++;
        }
        text(_highscore.substring(0, t[3]), 5, 0);
        
        //score
        fill(0, 0, 100);
        String _score = s[4] + String.valueOf(this.score);
        if(frameCount % textSpeed == 0 && t[3] >= _highscore.length() && t[4] < _score.length()){
          this.sound.playSound("talk", 30);
          t[4]++;
        }
        textAlign(LEFT, CENTER);
        text(_score.substring(0, t[4]), 5, 80);
        
        //comment
        fill(0, 0, 100);
        if(this.score < 300){
          _s = s[5];
          scoreImage = this.image.getImage("hiyoko", 250, 250);
        }else if(this.score >= 300 && this.score < 750){
          _s = s[6];
          scoreImage = this.image.getImage("chicken", 250, 250);
          this.titleImageJSON.setBoolean("chicken", true);
        }else if(this.score >= 750 && this.score < 1500){
          _s = s[7];
          scoreImage = this.image.getImage("penguin", 250, 250);
          this.titleImageJSON.setBoolean("penguin", true);
        }else if(this.score >= 1500 && this.score < 3000){
          _s = s[8];
          scoreImage = this.image.getImage("owl", 250, 250);
          this.titleImageJSON.setBoolean("owl", true);
        }else if(this.score >= 3000 && this.score < 6000){
          _s = s[9];
          scoreImage = this.image.getImage("kite", 250, 250);
          this.titleImageJSON.setBoolean("kite", true);
        }else if(this.score >= 6000){
          _s = s[10];
          scoreImage = this.image.getImage("hawk", 250, 250);
          this.titleImageJSON.setBoolean("hawk", true);
        }
        if(frameCount % textSpeed == 0 && t[4] >= _score.length() && t[5] < _s.length()){
          this.sound.playSound("talk", 30);
          t[5]++;
        }
        textAlign(LEFT, BOTTOM);
        text(_s.substring(0, t[5]), 5, height);
        
        if(t[5] >= _s.length() && t[6] <= 30){
          t[6]++;
        }
        
        if(t[6] > 30){
          if(this.soundFlag){
            this.soundFlag = false;
            this.sound.playSound("talk", 30);
          }
          scoreImage.resize(250, 250);
          image(scoreImage, width - 250, height - 250);
        }
        
        this.saveTitleImage(this.titleImageJSON);
        this.hiyoko.showPlayer();
        
        if(this.score > this.highscore){
          saveHighscore(this.score);
        }
        if (this.x >= width/2 - 115 && this.x <= width/2+105 && this.y >= height/1.5-30 && this.y <= height/1.5+40) {
          this.highscore = loadHighscore();
          this.sound.stopMusic();
          this.state = "start";
          this.x = 0;
          this.y = 0;
          this.musicFlag = true;
          this.soundFlag = true;
          this.hiyoko = new Player(this.playerImage);
  
        }
        
        if (this.x >= width/2 - 140 && this.x <= width/2+125 && this.y >= height/2-25 && this.y <= height/2+40) {
          this.highscore = loadHighscore();
          this.score = 0;
          this.sound.stopMusic();
          this.state = "game";
          this.enemyFrame = frameCount;
          this.x = 0;
          this.y = 0;
          this.musicFlag = true;
          this.soundFlag = true;
          this.hiyoko = new Player(this.playerImage);
          for (int i = 0; i<3; i++){
            this.item[i] = new Item(this.itemImage);
            this.enemy[i] = new Enemy(this.enemyImage);
          }
          for(int i = 0; i < 6; i++)
            this.t[i] = 0;
        }
        break;
      //-------------------------tutorial----------------------------------
      case "tutorial1":
        image(this.image.getImage("tutorialBack", width, height), 0, 0);
        String text1 = "まうすそうさで\nひよこをうごかしてね";
        textAlign(CENTER, CENTER);
        fill(0);
        text(text1, width/2, height/2);
        
        if(mouseX >= width-250 && mouseY <= 250)
          image(this.image.getImage("hiyoko_damage", 250, 250), width-250, 0);
        else
          image(this.image.getImage("hiyoko", 250, 250), width-250, 0);
        
        if(mouseX <= 90 && mouseY <= 90)
          image(this.image.getImage("cross_hover", 90, 90), 0, 0);
        else
          image(this.image.getImage("cross_normal", 90, 90), 0, 0);
          
        if(mouseX >= width-90 && mouseY >= height-90)
          image(this.image.getImage("arrow_hover_r", 90, 90), width-90, height-90);
        else
          image(this.image.getImage("arrow_normal_r", 90, 90), width-90, height-90);
        
        if(this.x >= width-90 && this.y >= height-90){
          this.x = 0;
          this.y = 0;
          this.state = "tutorial2";
        }
        
        if(this.x <= 90 && this.y <= 90 && this.x != 0 && this.y != 0){
          this.x = 0;
          this.y = 0;
          this.state = "start";
        }
        
        this.hiyoko.showPlayer();
        break;
      
      case "tutorial2":
        image(this.image.getImage("tutorialBack", width, height), 0, 0);
        String text2 = "おこめをたべて\nぽいんとをかせごう！";
        textAlign(CENTER,CENTER);
        fill(0);
        text(text2, width/2, height/2);
        
        if(mouseX >= width-200 && mouseY <= 200 && mouseX <= width - 50 && mouseY >= 30)
          if(frameCount % 60 < 30)
            image(this.image.getImage("item_rare1", 250, 250), width-250, 0);
          else
            image(this.image.getImage("item_rare2", 250, 250), width-250, 0);
        else
          image(this.image.getImage("item_normal", 250, 250), width-250, 0);
        
        if(mouseX <= 90 && mouseY <= 90)
          image(this.image.getImage("cross_hover", 90, 90), 0, 0);
        else
          image(this.image.getImage("cross_normal", 90, 90), 0, 0);
        
        if(mouseX >= width-90 && mouseY >= height-90)
          image(this.image.getImage("arrow_hover_r", 90, 90), width-90, height-90);
        else
          image(this.image.getImage("arrow_normal_r", 90, 90), width-90, height-90);
        
        if(mouseX <= 90 && mouseY >= height-90)
          image(this.image.getImage("arrow_hover_l", 90, 90), 0, height-90);
        else
          image(this.image.getImage("arrow_normal_l", 90, 90), 0, height-90);
          
        if(this.x >= width-90 && this.y >= height-90){
          this.x = 0;
          this.y = 0;
          this.state = "tutorial3";
        }
        
        if(this.x <= 90 && this.y >= height-90){
          this.x = 0;
          this.y = 0;
          this.state = "tutorial1";
        }
        
        if(this.x <= 90 && this.y <= 90 && this.x != 0 && this.y != 0){
          this.x = 0;
          this.y = 0;
          this.state = "start";
        }
        
        this.hiyoko.showPlayer();
        break;
      
      case "tutorial3":
        image(this.image.getImage("tutorialBack", width, height), 0, 0);
        String text3 = "からすにあたると\nたいりょくがへるよ！\nあかいからすには\nとくにちゅういしよう！";
        textAlign(CENTER, CENTER);
        fill(0);
        text(text3, width/2, height/2);
        
        if(mouseX >= width-250 && mouseY <= 250 && mouseY >= 50)
          image(this.image.getImage("RedClow1", 250, 250), width-250, 0);
        else
          image(this.image.getImage("Clow2", 250, 250), width-250, 0);
        
        if(mouseX <= 90 && mouseY <= 90)
          image(this.image.getImage("cross_hover", 90, 90), 0, 0);
        else
          image(this.image.getImage("cross_normal", 90, 90), 0, 0);
        
        if(mouseX >= width-90 && mouseY >= height-90)
          image(this.image.getImage("arrow_hover_r", 90, 90), width-90, height-90);
        else
          image(this.image.getImage("arrow_normal_r", 90, 90), width-90, height-90);
        
        if(mouseX <= 90 && mouseY >= height-90)
          image(this.image.getImage("arrow_hover_l", 90, 90), 0, height-90);
        else
          image(this.image.getImage("arrow_normal_l", 90, 90), 0, height-90);
        
        if(this.x >= width-90 && this.y >= height-90){
          this.x = 0;
          this.y = 0;
          this.state = "tutorial4";
        }
        
        if(this.x <= 90 && this.y >= height-90){
          this.x = 0;
          this.y = 0;
          this.state = "tutorial2";
        }
        
        if(this.x <= 90 && this.y <= 90 && this.x != 0 && this.y != 0){
          this.x = 0;
          this.y = 0;
          this.state = "start";
        }
        
        this.hiyoko.showPlayer();
        break;
      
      case "tutorial4":
        image(this.image.getImage("tutorialBack", width, height), 0, 0);
        String text4 = "たいりょくがへったら\nはーとをとってかいふくしよう！";
        textAlign(CENTER,CENTER);
        fill(0);
        text(text4, width/2, height/2);
        
        if(mouseX >= width-200 && mouseY <= 220 && mouseX <= width - 50 && mouseY >= 80)
          if(frameCount % 60 < 30)
            image(this.image.getImage("recoverHP_rare1", 250, 250), width-250, 0);
          else
            image(this.image.getImage("recoverHP_rare2", 250, 250), width-250, 0);
        else
          image(this.image.getImage("recoverHP_normal", 250, 250), width-250, 0);
        
        if(mouseX <= 90 && mouseY <= 90)
          image(this.image.getImage("cross_hover", 90, 90), 0, 0);
        else
          image(this.image.getImage("cross_normal", 90, 90), 0, 0);
        
        if(mouseX <= 90 && mouseY >= height-90)
          image(this.image.getImage("arrow_hover_l", 90, 90), 0, height-90);
        else
          image(this.image.getImage("arrow_normal_l", 90, 90), 0, height-90);
        
        if(this.x <= 90 && this.y >= height-90){
          this.x = 0;
          this.y = 0;
          this.state = "tutorial3";
        }
        
        if(this.x <= 90 && this.y <= 90 && this.x != 0 && this.y != 0){
          this.x = 0;
          this.y = 0;
          this.state = "start";
        }
        
        this.hiyoko.showPlayer();
        break;
      
      case "choiceBird1":
        background(0, 0, 90);
        if(mouseX <= 90 && mouseY <= 90)
          image(this.image.getImage("cross_hover", 90, 90), 0, 0);
        else
          image(this.image.getImage("cross_normal", 90, 90), 0, 0);
          
        if(mouseX >= width-90 && mouseY >= height-90)
          image(this.image.getImage("arrow_hover_r", 90, 90), width-90, height-90);
        else
          image(this.image.getImage("arrow_normal_r", 90, 90), width-90, height-90);
          
        if(this.x <= 90 && this.y <= 90 && this.x != 0 && this.y != 0){
          this.x = 0;
          this.y = 0;
          this.state = "start";
        }
        
        if(this.x >= width-90 && this.y >= height-90){
          this.x = 0;
          this.y = 0;
          this.state = "choiceBird2";
        }
        
        setImage(this.image.getImage("hiyoko", 250, 250), width/5, height/2, 250);
        if(this.titleImageJSON.getBoolean("chicken"))
          setImage(this.image.getImage("chicken", 250, 250), width/2, height/2, 250);
        else
          setImage(this.image.getImage("exclamation", 250, 250), width/2, height/2, 250);
          
        if(this.titleImageJSON.getBoolean("penguin"))
          setImage(this.image.getImage("penguin", 250, 250), width/1.25, height/2, 250);
        
        else
          setImage(this.image.getImage("exclamation", 250, 250), width/1.25, height/2, 250);
        
        if(this.x >= width/5-125 && this.x <= width/5+125 && this.y >= height/2-125 && this.y <= height/2+125 && this.titleImageJSON.getBoolean("hiyoko")){
          this.titleImageJSON.setString("nowImage", "hiyoko");
          this.x = 0;
          this.y = 0;
          this.state = "start";
          this.saveTitleImage(this.titleImageJSON);
        }
        if(this.x >= width/2-125 && this.x <= width/2+125 && this.y >= height/2-125 && this.y <= height/2+125 && this.titleImageJSON.getBoolean("chicken")){
          this.titleImageJSON.setString("nowImage", "chicken");
          this.x = 0;
          this.y = 0;
          this.state = "start";
          this.saveTitleImage(this.titleImageJSON);
        }
        if(this.x >= width/1.25-125 && this.x <= width/1.25+125 && this.y >= height/2-125 && this.y <= height/2+125 && this.titleImageJSON.getBoolean("penguin")){
          this.titleImageJSON.setString("nowImage", "penguin");
          this.x = 0;
          this.y = 0;
          this.state = "start";
          this.saveTitleImage(this.titleImageJSON);
        }
        this.hiyoko.showPlayer();
        break;
        
      case "choiceBird2":
        background(0, 0, 90);
        if(mouseX <= 90 && mouseY <= 90)
          image(this.image.getImage("cross_hover", 90, 90), 0, 0);
        else
          image(this.image.getImage("cross_normal", 90, 90), 0, 0);
          
        if(mouseX <= 90 && mouseY >= height-90)
          image(this.image.getImage("arrow_hover_l", 90, 90), 0, height-90);
        else
          image(this.image.getImage("arrow_normal_l", 90, 90), 0, height-90);
          
        if(this.x <= 90 && this.y <= 90 && this.x != 0 && this.y != 0){
          this.x = 0;
          this.y = 0;
          this.state = "start";
        }
        
        if(this.x <= 90 && this.y >= height-90){
          this.x = 0;
          this.y = 0;
          this.state = "choiceBird1";
        }
        
        if(this.titleImageJSON.getBoolean("owl"))
          setImage(this.image.getImage("owl", 250, 250), width/5, height/2, 250);
        else
          setImage(this.image.getImage("exclamation", 250, 250), width/5, height/2, 250);
          
        if(this.titleImageJSON.getBoolean("kite"))
          setImage(this.image.getImage("kite", 250, 250), width/2, height/2, 250);
        else
          setImage(this.image.getImage("exclamation", 250, 250), width/2, height/2, 250);
        
        if(this.titleImageJSON.getBoolean("hawk"))
          setImage(this.image.getImage("hawk", 250, 250), width/1.25, height/2, 250);
        else
          setImage(this.image.getImage("exclamation", 250, 250), width/1.25, height/2, 250);
        
        if(this.x >= width/5-125 && this.x <= width/5+125 && this.y >= height/2-125 && this.y <= height/2+125 && this.titleImageJSON.getBoolean("owl")){
          this.titleImageJSON.setString("nowImage", "owl");
          this.x = 0;
          this.y = 0;
          this.state = "start";
          this.saveTitleImage(this.titleImageJSON);
        }
        if(this.x >= width/2-125 && this.x <= width/2+125 && this.y >= height/2-125 && this.y <= height/2+125 && this.titleImageJSON.getBoolean("kite")){
          this.titleImageJSON.setString("nowImage", "kite");
          this.x = 0;
          this.y = 0;
          this.state = "start";
          this.saveTitleImage(this.titleImageJSON);
        }
        if(this.x >= width/1.25-125 && this.x <= width/1.25+125 && this.y >= height/2-125 && this.y <= height/2+125 && this.titleImageJSON.getBoolean("hawk")){
          this.titleImageJSON.setString("nowImage", "hawk");
          this.x = 0;
          this.y = 0;
          this.state = "start";
          this.saveTitleImage(this.titleImageJSON);
        }
        this.hiyoko.showPlayer();
        break;
    }
  }
}
