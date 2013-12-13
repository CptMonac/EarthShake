
import jp.nyatla.nyar4psg.MultiMarker;

import jp.nyatla.nyar4psg.NyAR4PsgConfig;

import org.openkinect.processing.Kinect;

//import com.sun.j3d.audioengines.headspace.AudioStream;

import processing.core.PApplet;
import processing.core.PFont;
import processing.core.PImage;
import hypermedia.video.*;
import java.awt.*;

import  java.io.*;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.SourceDataLine;

import krister.Ess.*;
import  sun.audio.*;    //import the sun.audio package
import  java.io.*;
import java.applet.*;
import java.awt.Color;
import java.awt.event.KeyEvent;
import javax.swing.*;
import java.awt.*;




public class Main1 extends PApplet 
{
	int minz = 400;
	int maxz = 400;
	MultiMarker nya,nya2;
	
	int numPixels;                      // number of pixels in the video
	int rectDivide = 4;                 // the stage width/height divided by this number is the video width/height 
	int vidW;                           // video width
	int vidH;                           // video height
	int[][] colouredPixels;             // the different colour references for each pixel
	int[][] colourCompareData;          // captured r, g and b colours
	int[][] colourCompareDataMin;          // captured r, g and b colours
	int[][] colourCompareDataMax;          // captured r, g and b colours
	int currR;                          //
	int currG;                          //
	int currB;                          //
	int minCalibRed = 500,maxCalibRed = 0,minCalibGreen = 500,maxCalibGreen = 0,minCalibBlue = 500,maxCalibBlue = 0,minCalibYellow=500,maxCalibYellow=0;
	double minCalibVR = 500,maxCalibVR = 0,minCalibUR = 500,maxCalibUR = 0;
	double minCalibVG = 500,maxCalibVG = 0,minCalibUG = 500,maxCalibUG = 0;
	double minCalibVB = 500,maxCalibVB = 0,minCalibUB = 500,maxCalibUB = 0;
	double minCalibVY = 500,maxCalibVY = 0,minCalibUY = 500,maxCalibUY = 0;
	
	int[][] squareCoords;               // x, y, w + h of the coloured areas
	Color[] colours;                    // captured colours
	int colourRange = 20;               // colour threshold
	int[][] centrePoints;               // centres of the coloured squares
	Color[] pixelColours;
	boolean isShowPixels = true;       // determines whether the square and coloured pixels are displayed
	int colourMax = 4;                  // max amount of colours - also adjust the amount of colours added to pixelColours in setup()
	int coloursAssigned = 0;            // amount of cours currently assigned
	double R,G,B,U,V;
	int colorToBeCalibrated = 1,calibrationCntr = 0;
	boolean entered1 = false,entered2 = false,entered3 = false,entered4 = false;
	
	int min1_G=650,min2_G=650,max1_G=0,max2_G=0;
	int min1_R=650,min2_R=650,max1_R=0,max2_R=0;
	int min1_B=650,min2_B=650,max1_B=0,max2_B=0;
	int min1_Y=650,min2_Y=650,max1_Y=0,max2_Y=0;
	int width_R1 = 0,width_G1 = 0,width_B1 = 0,width_Y1 = 0;
	int width_R2 = 0,width_G2 = 0,width_B2 = 0,width_Y2 = 0;
	int height_R1 = 0,height_B1 = 0,height_G1 = 0,height_Y1 = 0;
	int height_R2 = 0,height_B2 = 0,height_G2 = 0,height_Y2 = 0;
	int state_GUI = 1;
	int chosenBlock = 0;
	
	int endpoint_firstblock;
	
	boolean flag_R = false, flag_G, flag_B, flag_Y, flag_min1R_found,flag_min1G_found,flag_min1B_found,flag_min1Y_found;
	boolean flag2_R = false, flag2_G, flag2_B, flag2_Y, flag_min2R_found,flag_min2G_found,flag_min2B_found,flag_min2Y_found;
	boolean height_set = false;
	boolean fell_1= false,fell_2= false;
	boolean button_pressed = false;
	boolean firstblock_up = false,secondblock_up = false;
	
	int entered_endpt1_red=5,entered_endpt1_blue=5,entered_endpt1_green=5,entered_endpt1_yellow=5,entered_endpt2 = 5;
	boolean calibration_finished = false;
	AudioChannel myChannel; 
	int cursor_posX,cursor_posY;
	
	private final int BUFFER_SIZE = 128000;
    private File soundFile;
    private AudioInputStream audioStream;
    private AudioFormat audioFormat;
    private  SourceDataLine sourceLine;
    private boolean hiroFell = false;
    
    //int rectX, rectY;      // Position of square button 
    //int rectSize = 50;     // Diameter of rect
    int button1X,button1Y,button2X,button2Y,button3X,button3Y,button1XSize,button2XSize,button3XSize,button1YSize,button2YSize,button3YSize;
    int button4X,button4Y,button5X,button5Y,button6X,button6Y,button4XSize,button5XSize,button6XSize,button4YSize,button5YSize,button6YSize;
    
    Color rectColor, baseColor;
    Color rectHighlight;
    Color currentColor;
    boolean button1Over = false,button2Over = false,button3Over = false,button4Over = false,button5Over = false,button6Over = false;
    boolean left_fell = false,right_fell = false,both_fell = false;
    boolean right_wrong_played = false,right_right_played = false,left_wrong_played = false,left_right_played=false,same_wrong_played=false,same_right_played = false;
    boolean button1_played = false,button2_played = false,button3_played = false,button4_played = false,button5_played = false,button6_played = false;
	
    PImage screen1,screen2_shake1,screen2_shake2;
    boolean screenLoaded;
    int cntr=0;
    
    AudioClip ac_sameright,ac_samewrong,ac_rightright,ac_rightwrong,ac_leftright,ac_leftwrong,ac_next,ac_shaking,ac_chosesame,ac_chosesecond,ac_button1,ac_button2,ac_button3,ac_button4,ac_button5,ac_button6,ac_start,ac_chosefirst;
	
    FileWriter fWriter = null;
	BufferedWriter writer = null; 
	
	Kinect kinect = new Kinect(this);
	
	OpenCV opencv;
	
	PImage button;
	PFont fontA;
	int currentBlock = 1;
	int voiceOverDelay=0;
	
	public void setup()
	{
		
		//size(640,480,P3D);
		size(1500,550,P3D);
		
		/////////////////////////////////////////////////////
		////////////// GUI /////////////////////////////////
		////////////////////////////////////////////////////
		
		screen1 = loadImage("../screen1.jpg");
		image(screen1, 650, 0);
		screen2_shake1 = loadImage("../screen2-shake1.jpg");
		screen2_shake2 = loadImage("../screen2-shake2.jpg");
		
		
		
		
		fontA = loadFont("../Serif-48.vlw");
		  textFont(fontA, 20);
		  fill(0);
		  text("Which one do you think will fall first when I shake the table?", 860, 60);
		
		//////////////////////////////////////////////////////
		///////////// END OF GUI /////////////////////////////
		//////////////////////////////////////////////////////
		  
		 
		  
		  //sound
		  
		  //AudioClip ac = getAudioClip(getCodeBase(), "deneme.wav");
  		  //ac.play();   //play once
		
		kinect.start();
		kinect.enableDepth(true);
		noStroke();
		
		kinect.enableRGB(true);
		
		nya=new MultiMarker(this,width,height,"../camera_para.dat",NyAR4PsgConfig.CONFIG_PSG);
		nya.addARMarker("../patt.hiro",80);//id=0
		nya.addARMarker("../patt.kanji",80);//id=0
		//cd shift O
		 
		 
		
		System.out.println ("aaaa");
		
		vidW = kinect.getVideoImage().width / rectDivide;
		vidH = kinect.getVideoImage().height / rectDivide;
		
		  noStroke();
		  numPixels = kinect.getVideoImage().pixels.length;//vidW * vidH * 15;
		  colouredPixels = new int[kinect.getVideoImage().height][kinect.getVideoImage().width];
		  //colouredPixels = new int[vidH*15][vidW*15];
		  colourCompareData = new int[colourMax][3];
		  colourCompareDataMin = new int[colourMax][3];
		  colourCompareDataMax = new int[colourMax][3];
		  squareCoords = new int[colourMax][4];
		  colours = new Color[colourMax];
		  centrePoints = new int[colourMax][2];
		  Color c1 = new Color(0, 255, 0);
		  Color c2 = new Color(255, 0, 0);
		  pixelColours = new Color[colourMax];
		  
		 
		  V = (0.439 * R) - (0.368 * G) - (0.071 * B) + 128;
		  U = -(0.148 * R) - (0.291 * G) + (0.439 * B) + 128;
		  
		  pixelColours[0] = new Color(255, 0, 0);
		  
		  
		  pixelColours[1] = new Color(0, 0, 255);
		  
		  
		  pixelColours[2] = new Color(255, 255, 0);
		  
		  
		  pixelColours[3] = new Color(0, 255, 0);
		  
		  //red
		  coloursAssigned = 1;
		  colourCompareData[0][0] = 100;
		  colourCompareData[0][1] = 20;
		  colourCompareData[0][2] = 60;
		  colours[0] = new Color(100,20,60);
		  
		  //blue
		  coloursAssigned = 2;
		  colourCompareData[1][0] = 4;
		  colourCompareData[1][1] = 22;
		  colourCompareData[1][2] = 71;
		  colours[1] = new Color(4, 22, 71);
		  
		  //yellow
		  coloursAssigned = 3;
		  colourCompareData[2][0] = 136;
		  colourCompareData[2][1] = 97;
		  colourCompareData[2][2] =19;
		  colours[2] = new Color(136, 97, 19);
		  
		  //green
		  coloursAssigned = 4;
		  colourCompareData[3][0] = 6;
		  colourCompareData[3][1] = 76;
		  colourCompareData[3][2] = 41;
		  colours[3] = new Color(6, 76, 41);
		  
		  opencv = new OpenCV( this );
		  opencv.capture(kinect.getVideoImage().width,kinect.getVideoImage().height);
		  
		  cursor_posX = kinect.getVideoImage().width/2;
		  cursor_posY = kinect.getVideoImage().height/2;
		  
		  ac_start = getAudioClip(getCodeBase(), "../start.wav");
		  ac_sameright = getAudioClip(getCodeBase(), "../same_right.wav");
		  ac_samewrong = getAudioClip(getCodeBase(), "../same_wrong.wav");
		  ac_rightright = getAudioClip(getCodeBase(), "../right_right.wav");
		  ac_rightwrong = getAudioClip(getCodeBase(), "../right_wrong.wav");
		  ac_leftright = getAudioClip(getCodeBase(), "../left_right.wav");
		  ac_leftwrong = getAudioClip(getCodeBase(), "../left_wrong.wav");
		  ac_next = getAudioClip(getCodeBase(), "../next.wav");
		  ac_chosesame = getAudioClip(getCodeBase(), "../chosesame.wav");
		  ac_shaking = getAudioClip(getCodeBase(), "../shaking.wav");
		  ac_button1 = getAudioClip(getCodeBase(), "../button1.wav");
		  ac_button2 = getAudioClip(getCodeBase(), "../button2.wav");
		  ac_button3 = getAudioClip(getCodeBase(), "../botton3.wav");
		  ac_button4 = getAudioClip(getCodeBase(), "../button4.wav");
		  ac_button5 = getAudioClip(getCodeBase(), "../button5.wav");
		  ac_button6 = getAudioClip(getCodeBase(), "../button6.wav");
		  ac_chosefirst = getAudioClip(getCodeBase(), "../chosefirst.wav");
		  ac_chosesecond = getAudioClip(getCodeBase(), "../chosesecond.wav");
		    
		  try {
			  fWriter = new FileWriter("../study48T1-data");
			  writer = new BufferedWriter(fWriter);
			  //WRITES 1 LINE TO FILE AND CHANGES LINE
			  //writer.write("starting");
			  //writer.newLine();
			  //writer.close();
			} catch (Exception e) {
				
			}
	}
	 
	public void mousePressed()
	{
		
		System.out.println(button2Over+" "+state_GUI);
	  
	  if(button1Over && state_GUI == 1 ) {
	    System.out.println("button 1 clicked");
	    System.out.println("state 1_question");
		//screen1 = loadImage("screen1.jpg");
		image(screen1, 650, 0);
		state_GUI++;
		fill(0);
		text("You chose the first tower. Why do you think it will fall first?", 865, 45);
		text("Discuss with your partner.", 865, 65);
		text("When you are done click SHAKE button to see the result.", 865, 85);
		
		ac_chosefirst.play();   //play once
		
		ac_sameright.stop();
	    ac_samewrong.stop();
	    ac_rightright.stop();
	    ac_rightwrong.stop();
	    ac_leftright.stop();
	    ac_leftwrong.stop();
	    ac_next.stop();
	    ac_shaking.stop();
	    ac_chosesame.stop();
	    ac_chosesecond.stop();
	    ac_button1.stop();
	    ac_button2.stop();
	    ac_button3.stop();
	    ac_button4.stop();
	    ac_button5.stop();
	    ac_button6.stop();
	    ac_start.stop();
		  
		chosenBlock =1 ;
		
		try {
			  //WRITES 1 LINE TO FILE AND CHANGES LINE
			  writer.write("Chose first tower "+hour()+":"+minute()+":"+second());
			  writer.newLine();
			  //writer.close();
			} catch (Exception e) {
				
			}
		
	  }
	  
	  else if(button2Over && state_GUI == 1 ) {
		    System.out.println("button 2 clicked");
		    System.out.println("state 1_question");
			//screen1 = loadImage("screen1.jpg");
			image(screen1, 650, 0);
			state_GUI++;
			fill(0);
			text("You chose the second tower. Why do you think it will fall first?", 865, 45);
			text("Discuss with your partner.", 865, 65);
			text("When you are done click SHAKE button to see the result.", 865, 85);
			chosenBlock = 2;
			
			ac_chosesecond.play();   //play once
			
			ac_sameright.stop();
		    ac_samewrong.stop();
		    ac_rightright.stop();
		    ac_rightwrong.stop();
		    ac_leftright.stop();
		    ac_leftwrong.stop();
		    ac_next.stop();
		    ac_shaking.stop();
		    ac_chosesame.stop();
		    ac_start.stop();
		    ac_button1.stop();
		    ac_button2.stop();
		    ac_button3.stop();
		    ac_button4.stop();
		    ac_button5.stop();
		    ac_button6.stop();
		    ac_chosefirst.stop();
		    
		    try {
				  //WRITES 1 LINE TO FILE AND CHANGES LINE
				  writer.write("Chose second tower "+hour()+":"+minute()+":"+second());
				  writer.newLine();
				  //writer.close();
				} catch (Exception e) {
					
				}
	  }
	  
	  else if(button3Over && state_GUI == 1 ) {
		    System.out.println("button 3 clicked");
		    System.out.println("state 1_question");
			//screen1 = loadImage("screen1.jpg");
			image(screen1, 650, 0);
			state_GUI++;
			fill(0);
			text("You said they'll fall at the same time. Why do you think so?", 865, 45);
			text("Discuss with your partner.", 865, 65);
			text("When you are done click SHAKE button to see the result.", 865, 85);
			chosenBlock = 3;
			
			ac_chosesame.play();   //play once
			
			ac_sameright.stop();
		    ac_samewrong.stop();
		    ac_rightright.stop();
		    ac_rightwrong.stop();
		    ac_leftright.stop();
		    ac_leftwrong.stop();
		    ac_next.stop();
		    ac_shaking.stop();
		    ac_start.stop();
		    ac_chosesecond.stop();
		    ac_button1.stop();
		    ac_button2.stop();
		    ac_button3.stop();
		    ac_button4.stop();
		    ac_button5.stop();
		    ac_button6.stop();
		    ac_chosefirst.stop();
		    
		    try {
				  //WRITES 1 LINE TO FILE AND CHANGES LINE
				  writer.write("Chose same time "+hour()+":"+minute()+":"+second());
				  writer.newLine();
				  //writer.close();
				} catch (Exception e) {
					
				}
			
	  }
	  
	  else if(button2Over && state_GUI == 2 ) {
		    System.out.println("button 2 clicked");
		    System.out.println("state 1_question");
			//screen1 = loadImage("screen1.jpg");
			image(screen1, 650, 0);
			state_GUI++;
			fill(0);
			text("I'm shaking the table. Let's see which one falls first!", 875, 65);
			
			ac_shaking.play();   //play once
			
			ac_sameright.stop();
		    ac_samewrong.stop();
		    ac_rightright.stop();
		    ac_rightwrong.stop();
		    ac_leftright.stop();
		    ac_leftwrong.stop();
		    ac_next.stop();
		    ac_start.stop();
		    ac_chosesame.stop();
		    ac_chosesecond.stop();
		    ac_button1.stop();
		    ac_button2.stop();
		    ac_button3.stop();
		    ac_button4.stop();
		    ac_button5.stop();
		    ac_button6.stop();
		    ac_chosefirst.stop();
			
	  }
	  
	  else if( (button1Over || button2Over || button3Over || button4Over || button5Over || button6Over) && state_GUI == 4 && voiceOverDelay >=150 ) {
		    System.out.println("button why clicked");
			image(screen1, 650, 0);
			state_GUI = 5;
			
			ac_next.play();  
			
			ac_sameright.stop();
		    ac_samewrong.stop();
		    ac_rightright.stop();
		    ac_rightwrong.stop();
		    ac_leftright.stop();
		    ac_leftwrong.stop();
		    ac_start.stop();
		    ac_shaking.stop();
		    ac_chosesame.stop();
		    ac_chosesecond.stop();
		    ac_button1.stop();
		    ac_button2.stop();
		    ac_button3.stop();
		    ac_button4.stop();
		    ac_button5.stop();
		    ac_button6.stop();
		    ac_chosefirst.stop();
		    
		    if (button1Over)
			    try {
					  //WRITES 1 LINE TO FILE AND CHANGES LINE
					  writer.write("Because it is smaller "+hour()+":"+minute()+":"+second());
					  writer.newLine();
					  //writer.close();
					} catch (Exception e) {
						
					}
		    
		    if (button2Over)
			    try {
					  //WRITES 1 LINE TO FILE AND CHANGES LINE
					  writer.write("Because it is taller "+hour()+":"+minute()+":"+second());
					  writer.newLine();
					  //writer.close();
					} catch (Exception e) {
						
					}
		    if (button3Over)
			    try {
					  //WRITES 1 LINE TO FILE AND CHANGES LINE
					  writer.write("Because it has more weight on top than bottom "+hour()+":"+minute()+":"+second());
					  writer.newLine();
					  //writer.close();
					} catch (Exception e) {
						
					}
		    if (button4Over)
			    try {
					  //WRITES 1 LINE TO FILE AND CHANGES LINE
					  writer.write("Because it has a wider base "+hour()+":"+minute()+":"+second());
					  writer.newLine();
					  //writer.close();
					} catch (Exception e) {
						
					}
		    if (button5Over)
			    try {
					  //WRITES 1 LINE TO FILE AND CHANGES LINE
					  writer.write("Because it is not symmetrical  "+hour()+":"+minute()+":"+second());
					  writer.newLine();
					  //writer.close();
					} catch (Exception e) {
						
					}
		    if (button6Over)
			    try {
					  //WRITES 1 LINE TO FILE AND CHANGES LINE
					  writer.write("Because it has a thinner base "+hour()+":"+minute()+":"+second());
					  writer.newLine();
					  //writer.close();
					} catch (Exception e) {
						
					}
			 
	  }
	  
	  else if(button2Over && state_GUI == 5 ) {
		    System.out.println("next clicked");
			image(screen1, 650, 0);
			state_GUI = 1;
			
			ac_start.play();   //play once
			
			ac_sameright.stop();
		    ac_samewrong.stop();
		    ac_rightright.stop();
		    ac_rightwrong.stop();
		    ac_leftright.stop();
		    ac_leftwrong.stop();
		    ac_next.stop();
		    ac_shaking.stop();
		    ac_chosesame.stop();
		    ac_chosesecond.stop();
		    ac_button1.stop();
		    ac_button2.stop();
		    ac_button3.stop();
		    ac_button4.stop();
		    ac_button5.stop();
		    ac_button6.stop();
		    ac_chosefirst.stop();
			  
			  left_right_played = false;
			  left_wrong_played = false;
			  right_right_played = false;
			  right_wrong_played = false;
			  same_right_played = false;
			  same_wrong_played = false;
			  
			  currentBlock++;
			  
			  if (currentBlock==12){
					try {
											  
						 writer.close();
							} catch (Exception e) {
							}
			  }
	  }
	    
		
	  
	}
	
	
	public boolean overRect(int x, int y, int width, int height) 
	{
	  if (mouseX >= x && mouseX <= x+width && 
	      mouseY >= y && mouseY <= y+height) {
	    return true;
	  } else {
	    return false;
	  }
	}
	
	
	boolean overCircle(int x, int y, int diameter) 
	{
		
	  float disX = x - mouseX;
	  float disY = y - mouseY;
	  if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
		  //System.out.println("overcircle");
	    return true;
	  } else {
	    return false;
	  }
	}
	
	
	public void stop() {
		  Ess.stop();
		  super.stop();
		}
	
	
	public void draw()
	{
		
		//////// gui //////////
		
		//System.out.println(state_GUI);
		
		  if ((state_GUI == 1) && overCircle(button1X, button1Y, button1XSize)) {
			
		    button1Over = true;
		    System.out.println("button1over");
		    
		  } else {
			fill(255,0,0);
		    button1Over = false;
		  }
		  
		  if ((state_GUI == 1 || state_GUI == 2 || state_GUI == 5) && overCircle(button2X, button2Y, button2XSize) ) {
			  //System.out.println("button2over true");
			    button2Over = true;
			    
			  } else {
				fill(255,0,0);
				//System.out.println("button2over false");
			    button2Over = false;
			  }
		  
		  if ( (state_GUI == 1) && overCircle(button3X, button3Y, button3XSize) ) {
			  //System.out.println("button3over");
			    button3Over = true;
			    
			  } else {
				fill(255,0,0);
			    button3Over = false;
			  }
		  
		  if ( state_GUI == 4) {
				if (overRect(button1X, button1Y, button1XSize, button1YSize) ) {
				   //System.out.println("button1over rect");
				    button1Over = true;
				    if (button1_played == false && same_right_played == true){
				    	//System.out.println("play button1");
				    	ac_button1.play();
				    	button1_played = true;
				    	
				    	
					    ac_button2.stop();
					    ac_button3.stop();
					    ac_button4.stop();
					    ac_button5.stop();
					    ac_button6.stop();
				    }
				    
				    
				  } else {
					fill(255,0,0);
				    button1Over = false;
				    button1_played = false;
				  }
			  
				 if (overRect(button2X, button2Y, button2XSize, button2YSize) ) {
				    //System.out.println("button2over rect");
				    button2Over = true;
				    if (button2_played == false && same_right_played == true){
				    	//System.out.println("play button2");
				    	ac_button2.play();
				    	button2_played = true;
				    	
					    ac_button1.stop();
					    ac_button3.stop();
					    ac_button4.stop();
					    ac_button5.stop();
					    ac_button6.stop();
				    }
				    
				  } else {
					fill(255,0,0);
				    button2Over = false;
				    //System.out.println("button2over false");
				    button2_played = false;
				  }
			  
				 if ( overRect(button3X, button3Y, button3XSize, button3YSize) ) {
					//System.out.println("button3over rect");
				    button3Over = true;
				    if (button3_played == false && same_right_played == true){
				    	//System.out.println("play button3");
				    	ac_button3.play();
				    	button3_played = true;
				    	
					    ac_button1.stop();
					    ac_button2.stop();
					    ac_button4.stop();
					    ac_button5.stop();
					    ac_button6.stop();
				    }
				    
				    
				  } else {
					fill(255,0,0);
				    button3Over = false;
				    button3_played = false;
				  }
			  
				 if ( overRect(button4X, button4Y, button4XSize, button4YSize) ) {
					 //System.out.println("button4over rect");
				    button4Over = true;
				    if (button4_played == false && same_right_played == true){
				    	//System.out.println("play button4");
				    	ac_button4.play();
				    	
					    ac_button1.stop();
					    ac_button2.stop();
					    ac_button3.stop();
					    ac_button5.stop();
					    ac_button6.stop();
					    
				    	button4_played = true;
				    }
				    
				  } else {
					fill(255,0,0);
				    button4Over = false;
				    button4_played = false;
				  }
			  
				 if ( overRect(button5X, button5Y, button5XSize, button5YSize) ) {
					//System.out.println("button5over rect");
				    button5Over = true;
				    if (button5_played == false && same_right_played == true){
				    	//System.out.println("play button5");
				    	ac_button5.play();
				    	button5_played = true;
				    	
					    ac_button1.stop();
					    ac_button2.stop();
					    ac_button3.stop();
					    ac_button4.stop();
					    ac_button6.stop();
				    }
				    
				  } else {
					fill(255,0,0);
				    button5Over = false;
				    button5_played = false;
				  }
			  
				 if ( overRect(button6X, button6Y, button6XSize, button6YSize) ) {
					//System.out.println("button6over rect");
				    button6Over = true;
				    if (button6_played == false && same_right_played == true){
				    	//System.out.println("play button6");
				    	ac_button6.play();
				    	
					    ac_button1.stop();
					    ac_button2.stop();
					    ac_button3.stop();
					    ac_button4.stop();
					    ac_button5.stop();
					    
				    	button6_played = true;
				    }
				    
				  } else {
					fill(255,0,0);
				    button6Over = false;
				    button6_played = false;
				  }
		  }
		  
		  if(state_GUI==1 && screenLoaded == true){
			  //System.out.println("gui 1");
			  image(screen1, 650, 0);
			  fill(0);
			  text("Which one do you think will fall first when I shake the table?", 860, 60);
			
			  rectColor = new Color(50,50,50);
			  rectHighlight = new Color(80,80,80);
			  fill (244, 164, 96);
			  button1X = 1020;
			  button1Y = 420;	
			  button1XSize = 80;
			  button1YSize = 50;
			  ellipse(button1X, button1Y, button1XSize, button1YSize);
			  fill(0);
			  text("1", 1015, 425);
			  
			  fill (244, 164, 96);
			  button2X = 1170;
			  button2Y = 420;	
			  button2XSize = 80;
			  button2YSize = 50;
			  ellipse(button2X, button2Y, button2XSize, button2YSize);
			  fill(0);
			  text("2", 1165, 425);
			  
			  fill (244, 164, 96);
			  button3X = 1320;
			  button3Y = 420;
			  button3XSize = 80;
			  button3YSize = 50;
			  ellipse(button3X, button3Y, button3XSize, button3YSize);
			  fill(0);
			  text("Same", 1300, 425);
			
		  }
		  
		  else if(state_GUI==2){
			  image(screen1, 650, 0);
			  fill (244, 164, 96);
			  button2X = 1120;
			  button2Y = 420;	
			  button2XSize = 80;
			  button2YSize = 50;
			  ellipse(button2X, button2Y, button2XSize, button2YSize);
			  fill(0);
			  text("SHAKE", 1085, 425);
			  
			  if(chosenBlock == 1) {
				   
					fill(0);
					text("You chose the first tower. Why do you think it will fall first?", 865, 45);
					text("Discuss with your partner.", 865, 65);
					text("When you are done click SHAKE button to see the result.", 865, 85);
					
				  }
				  
			  else if(chosenBlock == 2) {
						fill(0);
						text("You chose the second tower. Why do you think it will fall first?", 865, 45);
						text("Discuss with your partner.", 865, 65);
						text("When you are done click SHAKE button to see the result.", 865, 85);
						
				  }
				  
			  else if(chosenBlock ==3 ) {
					    
						fill(0);
						text("You said they'll fall at the same time. Why do you think so?", 865, 45);
						text("Discuss with your partner.", 865, 65);
						text("When you are done click SHAKE button to see the result.", 865, 85);
						
				  }
		  }
		  
		  else if (state_GUI == 3){
			  
			  if (cntr%2 == 0)
				  image(screen2_shake1, 650, 0);
			  else 
				  image(screen2_shake2, 650, 0);
			  
			  cntr++;
				fill(0);
				text("I'm shaking the table. Let's see which one falls first!", 875, 65);
				
				if(left_fell == true || right_fell == true || both_fell == true)
					state_GUI++;
		  }
		  
		  else if (state_GUI == 4){
			  
			  //System.out.println("state_GUI 4");
			  
			  image(screen1, 650, 0);
			  voiceOverDelay++;
			  
			  if (both_fell == true){
				  
				  if (chosenBlock == 3){
					  fill(0);
					  text("Good job! Your hypothesis was right.", 875, 45);
					  text("They both fell at the same time.", 875, 65);
					  text("Why do you think they fell at the same time?", 875, 85);
					  
					  if (same_right_played == false){
						  ac_sameright.play();   //play once
						  
						    ac_start.stop();
						    ac_samewrong.stop();
						    ac_rightright.stop();
						    ac_rightwrong.stop();
						    ac_leftright.stop();
						    ac_leftwrong.stop();
						    ac_next.stop();
						    ac_shaking.stop();
						    ac_chosesame.stop();
						    ac_chosesecond.stop();
						    ac_button1.stop();
						    ac_button2.stop();
						    ac_button3.stop();
						    ac_button4.stop();
						    ac_button5.stop();
						    ac_button6.stop();
						    ac_chosefirst.stop();
						    
						  same_right_played = true;
					  }
				  }
				  else{
					  fill(0);
					  text("Oh oh you were wrong! They both fell at the same time.", 875, 55);
					  text("Why do you think they fell at the same time?", 875, 75);
					  
					  if (same_right_played == false){
						  ac_samewrong.play();   //play once
						  
						  ac_sameright.stop();
						    ac_start.stop();
						    ac_rightright.stop();
						    ac_rightwrong.stop();
						    ac_leftright.stop();
						    ac_leftwrong.stop();
						    ac_next.stop();
						    ac_shaking.stop();
						    ac_chosesame.stop();
						    ac_chosesecond.stop();
						    ac_button1.stop();
						    ac_button2.stop();
						    ac_button3.stop();
						    ac_button4.stop();
						    ac_button5.stop();
						    ac_button6.stop();
						    ac_chosefirst.stop();
						  same_right_played = true;
					  }
				  }
			  }
			  else if(left_fell == true){
				  
				  if (chosenBlock == 1){
					  fill(0);
					  text("Good job! Your hypothesis was right.", 875, 45);
					  text("The left tower fell first.", 875, 65);
					  text("Why do you think this tower fell first?", 875, 85);
					  
					  if (same_right_played == false){
						  ac_leftright.play();   //play once
						  same_right_played = true;
						  
						  ac_sameright.stop();
						    ac_samewrong.stop();
						    ac_rightright.stop();
						    ac_rightwrong.stop();
						    ac_start.stop();
						    ac_leftwrong.stop();
						    ac_next.stop();
						    ac_shaking.stop();
						    ac_chosesame.stop();
						    ac_chosesecond.stop();
						    ac_button1.stop();
						    ac_button2.stop();
						    ac_button3.stop();
						    ac_button4.stop();
						    ac_button5.stop();
						    ac_button6.stop();
						    ac_chosefirst.stop();
					  }
				  }
				  else{
					  fill(0);
					  text("Oh oh you were wrong! The left tower fell first.", 875, 55);
					  text("Why do you think this tower fell first?", 875, 75);
					  
					  if (same_right_played == false){
						  ac_leftwrong.play();   //play once
						  same_right_played = true;
						  
						  ac_sameright.stop();
						    ac_samewrong.stop();
						    ac_rightright.stop();
						    ac_rightwrong.stop();
						    ac_leftright.stop();
						    ac_start.stop();
						    ac_next.stop();
						    ac_shaking.stop();
						    ac_chosesame.stop();
						    ac_chosesecond.stop();
						    ac_button1.stop();
						    ac_button2.stop();
						    ac_button3.stop();
						    ac_button4.stop();
						    ac_button5.stop();
						    ac_button6.stop();
						    ac_chosefirst.stop();
					  }
				  }
					
			  }
			  else if(right_fell == true){
				  
				  if (chosenBlock == 2){
					  fill(0);
					  text("Good job! Your hypothesis was right.", 875, 45);
					  text("The right tower fell first.", 875, 65);
					  text("Why do you think this tower fell first?", 875, 85);
					  
					  if (same_right_played == false){
						  ac_rightright.play();   //play once
						  
						  ac_sameright.stop();
						    ac_samewrong.stop();
						    ac_start.stop();
						    ac_rightwrong.stop();
						    ac_leftright.stop();
						    ac_leftwrong.stop();
						    ac_next.stop();
						    ac_shaking.stop();
						    ac_chosesame.stop();
						    ac_chosesecond.stop();
						    ac_button1.stop();
						    ac_button2.stop();
						    ac_button3.stop();
						    ac_button4.stop();
						    ac_button5.stop();
						    ac_button6.stop();
						    ac_chosefirst.stop();
						    
						  same_right_played = true;
					  }
				  }
				  else{
					  fill(0);
					  text("Oh oh you were wrong! The right tower fell first.", 875, 55);
					  text("Why do you think this tower fell first?", 875, 75);
					  
					  if (same_right_played == false){
						  ac_rightwrong.play();   //play once
						  
						  ac_sameright.stop();
						    ac_samewrong.stop();
						    ac_rightright.stop();
						    ac_start.stop();
						    ac_leftright.stop();
						    ac_leftwrong.stop();
						    ac_next.stop();
						    ac_shaking.stop();
						    ac_chosesame.stop();
						    ac_chosesecond.stop();
						    ac_button1.stop();
						    ac_button2.stop();
						    ac_button3.stop();
						    ac_button4.stop();
						    ac_button5.stop();
						    ac_button6.stop();
						    ac_chosefirst.stop();
						    
						  same_right_played = true;
					  }
				  }
					
			  }
			  
			  
			  fill (244, 164, 96);
			  button1X = 890-650+640;
			  button1Y = 380;	
			  button1XSize = 230;
			  button1YSize = 30;
			  rect(button1X, button1Y, button1XSize, button1YSize);
			  fill(0);
			  text("Because it is smaller", 900-650+640, 400);
			  
			  fill (244, 164, 96);
			  button2X = 1150-650+640;
			  button2Y = 420;	
			  button2XSize = 270;
			  button2YSize = 30;
			  rect(button2X, button2Y, button2XSize, button2YSize);
			  fill(0);
			  text("Because it is taller", 1160-650+640, 440);
			  
			  fill (244, 164, 96);
			  button3X = 670-650+640;
			  button3Y = 460;	
			  button3XSize = 450;
			  button3YSize = 30;
			  rect(button3X, button3Y, button3XSize, button3YSize);
			  fill(0);
			  text("Because it has more weight on top than bottom", 680-650+640, 480);
			  
			  fill (244, 164, 96);
			  button4X = 1150-650+640;
			  button4Y = 380;	
			  button4XSize = 270;
			  button4YSize = 30;
			  rect(button4X, button4Y, button4XSize, button4YSize);
			  fill(0);
			  text("Because it has a wider base", 1160-650+640, 400);
			  
			  fill (244, 164, 96);
			  button5X = 670-650+640;
			  button5Y = 420;	
			  button5XSize = 450;
			  button5YSize = 30;
			  rect(button5X, button5Y, button5XSize, button5YSize);
			  fill(0);
			  text("Because it is not symmetrical (even on both sides)", 680-650+640, 440);
			  
			  fill (244, 164, 96);
			  button6X = 1150-650+640;
			  button6Y = 460;	
			  button6XSize = 270;
			  button6YSize = 30;
			  rect(button6X, button6Y, button6XSize, button6YSize);
			  fill(0);
			  text("Because it has a thinner base", 1160-650+640, 480);
			  
			  
		  }
		  
		  else if (state_GUI == 5){
			  
			  voiceOverDelay =0;
			  
			  //System.out.println("state_GUI 5");
			  
			  image(screen1, 650, 0);
			  
			  fill (244, 164, 96);
			  button2X = 1170;
			  button2Y = 420;	
			  button2XSize = 80;
			  button2YSize = 50;
			  ellipse(button2X, button2Y, button2XSize, button2YSize);
			  fill(0);
			  text("NEXT", 1145, 425);
			  
			  fill(0);
			  text("Click NEXT to move on to the next question.", 880, 60);
			  
			  //AudioClip ac = getAudioClip(getCodeBase(), "next.wav");
			  //ac.play();   
			  
			  //System.out.println("next "+state_GUI);
			  
			  
		  }
		  
		  /*
		  else if (state_GUI ==3)
			  rectSize = 150;
		  else if (state_GUI ==4)
			  rectSize = 100;
		  else if (state_GUI ==5)
			  rectSize = 120;
		  else if (state_GUI ==6)
			  rectSize = 180;
			  */
		  
		  
			  
		
		////// end of gui //////
		
		    

	    noStroke();
	    //fill(255, 255, 255);
	    //rect(0, 0, width, height);
	   

	    drawVideo();
	    update(); //draw pixels over video
	    
	    for (int i = 0; i < coloursAssigned; i++)
	    {
	      //if (isShowPixels) 
	        //drawSquare(i); // draws square arround the colored region
	    }
	    
					///////////////////////////////////
							  
					int w = kinect.getVideoImage().width;
					int h = kinect.getVideoImage().height;
					
					/*
					opencv.read();
					
					//image( opencv.image(), 10, 10 );	            // RGB image
				    //image( opencv.image(OpenCV.GRAY), 20+w, 10 );   // GRAY image
				    //image( opencv.image(OpenCV.MEMORY), 10, 20+h ); // image in memory

				    opencv.absDiff();
				    
				    opencv.copy(kinect.getVideoImage(), 0, 0, 640, 480, 0, 0, 640, 480);
				    
				    //image(opencv.image(), 0, 0, 640, 480);
					opencv.threshold( 80, 255, OpenCV.THRESH_BINARY );
					*/
					
					
		noStroke();
	    
	    if(colorToBeCalibrated == 1){
	    	fill(255,0,0);
	    	rect(cursor_posX,cursor_posY, 5, 5);
	    }
	    else if(colorToBeCalibrated == 2){
	    	fill(0,0,255);
	    	rect(cursor_posX,cursor_posY, 5, 5);
	    }
	    else if(colorToBeCalibrated == 3){
	    	fill(255,255,0);
	    	rect(cursor_posX,cursor_posY, 5, 5);
	    }
	    else if(colorToBeCalibrated == 4){
	    	fill(0,255,0);
	    	rect(cursor_posX,cursor_posY, 5, 5);
	    }
	    
	    //fill(0,255,0);
		//rect(400,  400, 150, 150);

		
	}
			
		
	void drawVideo()
	{
	  
	  for (int i = 0; i < coloursAssigned; i++)
	  {
	    fill(colours[i].getRGB()); // draw small rect showing color picked
	    rect(i * 10, vidH, 10, 10);
	  }
	  //kinect.getVideoImage().resize(vidW, vidH);
	  image(kinect.getVideoImage(), 0, 0);
	  noFill();
	  stroke(255, 0, 0);
	  strokeWeight(2);
	  //rect(vidW - 4, vidH - 4, 4, 4); // draw small red rect in the corner
	  
	  
	  
	}
	
	void update()
	  {
		
	    int currX = vidW;
	    int currW = 0;
	    boolean isYAssigned = false;
	    boolean isWAssigned = false;
	    int[] data = kinect.getRawDepth();
	    
	    firstblock_up = false;
	    secondblock_up = false;
	    
	      width_R1 = 0;
		  width_G1 = 0;
		  width_B1 = 0;
		  width_Y1 = 0;
		  
		  width_R2 = 0;
		  width_G2 = 0;
		  width_B2 = 0;
		  width_Y2 = 0;
		  
		  
		  	min1_G=650;
		    min1_R=650;
		    min1_B=650;
		    min1_Y=650;
		    
		    min2_G=650;
		    min2_R=650;
		    min2_B=650;
		    min2_Y=650;
		    
		    
		    max1_R = 0;
		    max1_G = 0;
		    max1_B = 0;
		    max1_Y = 0;

		    max2_R = 0;
		    max2_G = 0;
		    max2_B = 0;
		    max2_Y = 0;
		    
		    
		     height_R1 = 0;height_B1 = 0;height_G1 = 0;height_Y1 = 0;
			 height_R2 = 0;height_B2 = 0;height_G2 = 0;height_Y2 = 0;
			
		  entered_endpt1_red = 0;
		  entered_endpt1_green = 0;
		  entered_endpt1_blue = 0;
		  entered_endpt1_yellow = 0;
		  
		  entered_endpt2 = 0;
	    		
	    for (int j = 0; j < coloursAssigned; j++) 
	    {
	      currX = vidW;
	      currW = 0;
	      isYAssigned = false;
	      isWAssigned = false;
	      
	      noStroke();
	      
	      /*
	        if (abs(i / kinect.getVideoImage().width)>300){
      		fill(0,0,0);
      		rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 1, 1);
      	}
      	*/
	        
	      
      	
		////////////////////////////////////////////////////
		//end of drawing colored pixels on screen
		///////////////////////////////////////////////////
	 if (true){//calibration_finished){// && button_pressed == true) {
	   //if (entered_endpt1_red< 2 || entered_endpt1_yellow < 2 || entered_endpt1_blue < 2 || entered_endpt1_green < 2){  //button_pressed == true && 
		      
		   
		   
		   min1_G=650;
		    min1_R=650;
		    min1_B=650;
		    min1_Y=650;
		    
		    min2_G=650;
		    min2_R=650;
		    min2_B=650;
		    min2_Y=650;
		    
		    max1_R = 0;
		    max1_G = 0;
		    max1_B = 0;
		    max1_Y = 0;

		    max2_R = 0;
		    max2_G = 0;
		    max2_B = 0;
		    max2_Y = 0;
		    
		    
		    flag_R = false;
		    flag_Y = false;
		    flag_B = false;
		    flag_G = false;
		    
		    flag_min1R_found = false;
		    flag_min1G_found = false;
		    flag_min1B_found = false;
		    flag_min1Y_found = false;
		    
	    //finding starting points of first block
	      
	      for (int i = 0; i < numPixels; i++)
	      {
	    	  //debugging for detecting fall
	    	  
	    	  if (abs(i / kinect.getVideoImage().width)==399){
	        		fill(0,0,0);
	        		rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 1, 1);
	        	}
	    	  
	    	  if(isColourWithinRange(j) && data[i]>500 && data[i]<750)
		        {
		        	
		        	
		            fill(pixelColours[j].getRGB());
		            
		            //System.out.println("fill "+pixelColours[j].getRGB());
		            	            
		            rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 1, 1);
		            //rect((i % vidW) * rectDivide, (abs(i / vidW)) * rectDivide, 1 * rectDivide, 1 * rectDivide);
		             
		          
		        }
	    	  
	    	  if(data[i]==2047){
		        	
		        	double depth = 1.0 / (data[i] * -0.0030711016 + 3.3309495161);
		        	//System.out.println("depth"+depth);
		        	fill(255,255,255);
		        	rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 1, 1);
		        }
	    	  
	    	//System.out.println(i+" "+data[i]);
	        //colouredPixels[abs(i / vidW)][i % vidW] = 0;
	        colouredPixels[abs(i / kinect.getVideoImage().width)][i % kinect.getVideoImage().width] = 0;
	        int currColor = kinect.getVideoImage().pixels[i]; //??
	        currR = (currColor >> 16) & 0xFF;
	        currG = (currColor >> 8) & 0xFF;
	        currB = currColor & 0xFF;
	        
	        if (i%kinect.getVideoImage().width==0){
    			if(j==0){
    				flag_R = false;
    				flag2_R = false;
    			}
    			if(j==1){
    				flag_B = false;
    				flag2_B = false;
    			}
    			if(j==2){
    				flag_Y = false;
    				flag2_Y = false;
    			}
    			if(j==3){
    				flag_G = false;
    				flag2_G = false;
    			}
    			
    			if(j==0){
    				flag_min1R_found = false;
    				flag_min2R_found = false;
    				//System.out.println(flag_min1R_found+" "+i);
    			}
    			
    			if(j==1){
    				flag_min1B_found = false;
    				flag_min2B_found = false;
    			}
    			if(j==2){
    				flag_min1Y_found = false;
    				flag_min2Y_found = false;
    			}
    			if(j==3){
    				flag_min1G_found = false;
    				flag_min2G_found = false;
    			}
    			
        	}
	        
	        
	        if( isShowPixels && abs(i / kinect.getVideoImage().width)>300)// && data[i]>500 && data[i]<700)//isColourWithinRange(j)
	        {
	        	/////////////////////////////////////////
	        	if (j == 0)
	        		entered_endpt1_red++;
	        	if (j == 1)
	        		entered_endpt1_blue++;
	        	if (j == 2)
	        		entered_endpt1_yellow++;
	        	if (j == 3)
	        		entered_endpt1_green++;
	        	
	        	
	        	
	        	if (j==0 || j==1 || j==2 ||j==3){
	        		int cntr = 0;
		        	if (i>5*kinect.getVideoImage().width && i<kinect.getVideoImage().pixels.length-5*kinect.getVideoImage().width){
		        		
		        		
		        if (data[i]>500 && data[i]<750){
		        	currColor = kinect.getVideoImage().pixels[i+1];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+2];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+3];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+4];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+5];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+2*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+3*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+4*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+5*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-1];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-2];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-3];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-4];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-5];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-2*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-3*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-4*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-5*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        }
		        	
		        	/*
		        	if (j==0 && cntr == 0){
		        		fill(0,0,0);
		        		rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 1, 1);
		        	}
		        	*/
		        	
		        	
		        	//if(i%kinect.getVideoImage().width < min1_G)
	        			//min1_G = i%kinect.getVideoImage().width;
		        	
		        	//System.out.println(i%kinect.getVideoImage().width);
		        	
		        	if (cntr>15){
		        		
		        		if (j == 0){//red
		        			
		        			if(i%kinect.getVideoImage().width < min1_R){
		        				
		        				//fill (255,0,255);
			        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 5);
	 		    	        	
			        			min1_R = i%kinect.getVideoImage().width;
			        			flag_min1R_found = true;
			        			//System.out.println("min foundddddddd " + i%kinect.getVideoImage().width);
			        			
			        			if(abs(i / kinect.getVideoImage().width) > height_R1 )
			        				height_R1=(abs(i / kinect.getVideoImage().width));
			        			
			        			
		        			}
		        			if(abs(i%kinect.getVideoImage().width - min1_R)<20)
		        				flag_min1R_found = true;
		        			
		        			
		        		}
		        		
		        		if (j == 1){//blue
		        			//System.out.println("is min? " + i%kinect.getVideoImage().width);
		        			
		        			
		        			if(i%kinect.getVideoImage().width < min1_B){
		        				
		        				//fill (255,0,255);
			        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 5);
	 		    	        	
			        			min1_B = i%kinect.getVideoImage().width;
			        			flag_min1B_found = true;
			        			//System.out.println("min foundddddddd " + i%kinect.getVideoImage().width);
		        			
			        			if(abs(i / kinect.getVideoImage().width) > height_B1)
			        				height_B1=(abs(i / kinect.getVideoImage().width));
		        			}
		        			if(abs(i%kinect.getVideoImage().width - min1_B)<20)
		        				flag_min1B_found = true;
		        		}
		        		
		        		if (j == 2){//yellow
		        			if(i%kinect.getVideoImage().width < min1_Y){
		        				
		        				//fill (255,0,255);
			        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 5);
	 		    	        	
			        			min1_Y = i%kinect.getVideoImage().width;
			        			flag_min1Y_found = true;
			        			//System.out.println("min yellow foundddddddd " + i%kinect.getVideoImage().width);
			        			if(abs(i / kinect.getVideoImage().width) > height_Y1)
			        				height_Y1=(abs(i / kinect.getVideoImage().width));
		        			}
		        			if(abs(i%kinect.getVideoImage().width - min1_Y)<20)
		        				flag_min1Y_found = true;
		        		}
		        		
		        		if (j == 3){//green
		        			if(i%kinect.getVideoImage().width < min1_G){
		        				//fill (255,0,255);
			        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 5);
	 		    	        	
			        			min1_G = i%kinect.getVideoImage().width;
			        			flag_min1G_found = true;
			        			//System.out.println("min foundddddddd " + i%kinect.getVideoImage().width);
			        			if(abs(i / kinect.getVideoImage().width) > height_G1)
			        				height_G1=(abs(i / kinect.getVideoImage().width));
		        			}
		        			if(abs(i%kinect.getVideoImage().width - min1_G)<20)
		        				flag_min1G_found = true;
		        				
		        		}
		        		
		        			
		        		//else if(i%kinect.getVideoImage().width > max1_G)
		        			//max1_G = i%kinect.getVideoImage().width; 
		        		
		        	}
		        	
		        	//red	
 		        	if (j==0  && cntr==0 && i%kinect.getVideoImage().width > min1_R && flag_R == false && flag_min1R_found == true){
 		        		
 		        		
	 		        		if(max1_R == 0 && min1_R<300 ){ //??
	 		        			max1_R = min1_R;
	 		        			
	 		        			//fill (0,255,255);
	 		        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 1);
	 		    	        	
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width>=max1_R && i%kinect.getVideoImage().width<max1_R+150){
		 		        		max1_R = i%kinect.getVideoImage().width;
		 		        		flag_R = true;
		 		        		
		 		        		//fill (0,255,0);
	 		        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 1);
	 		        			
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width<max1_R-150 && data[i]!=2047){
	 		        			max1_R = i%kinect.getVideoImage().width;
	 		        			flag_R = true;
	 		        			
	 		        			//fill (100,100,100);
	 		        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 1);
	 		        			
	 		        		}
 		        		
 		        		
 		        	}
 		        	
 		        	//blue
 		        	if (j==1 && cntr==0 && i%kinect.getVideoImage().width > min1_B && flag_B == false && flag_min1B_found == true){
 		        		
 		        		
 		        		
	 		        		if(max1_B == 0 && min1_B<300   ){ //??
	 		        			max1_B = min1_B;
	 		        			
	 		        			//fill (0,255,255);
	 		        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 1);
	 		    	        	//System.out.println("max found 1 " +max1_B);
	 	 		        		
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width>=max1_B && i%kinect.getVideoImage().width<max1_B+150 ){
		 		        		max1_B = i%kinect.getVideoImage().width;
		 		        		flag_B = true;
		 		        		
		 		        		//fill (0,255,255);
	 		        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 1);
	 		        			//System.out.println("max found 2 " +max1_B);
	 	 		        		
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width<max1_B-150 && data[i]!=2047 ){
	 		        			max1_B = i%kinect.getVideoImage().width;
	 		        			flag_B = true;
	 		        			
	 		        			//fill (0,255,255);
	 		        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 1);
	 		        			//System.out.println("max found 3 " +max1_B);
	 	 		        		
	 		        		}
 		        		
 		        	}
 		        	
 		        	//yellow
 		        	if (j==2 && cntr==0 && i%kinect.getVideoImage().width > min1_Y && flag_Y == false && flag_min1Y_found == true){
 		        		
 		        		
	 		        		if(max1_Y == 0 && min1_Y<300 ){ //??
	 		        			max1_Y = min1_Y;
	 		        			
	 		        			//fill (0,255,255);
	 		        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 1);
	 		    	        	
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width>=max1_Y && i%kinect.getVideoImage().width<max1_Y+150){
		 		        		max1_Y = i%kinect.getVideoImage().width;
		 		        		flag_Y = true;
		 		        		
		 		        		//fill (0,255,0);
	 		        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 1);
	 		        			
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width<max1_Y-150 && data[i]!=2047){
	 		        			max1_Y = i%kinect.getVideoImage().width;
	 		        			flag_Y = true;
	 		        			
	 		        			//fill (100,100,100);
	 		        			//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 1);
	 		        			
	 		        		}
 		        		
 		        	}
 		        	
 		        	//green
 		        	if (j==3 && cntr==0 && i%kinect.getVideoImage().width > min1_G && flag_G == false && flag_min1G_found == true){
 		        		
 		        		
	 		        		if(max1_G == 0 && min1_G<300){
	 		        			max1_G = min1_G;
	 		        			
	 		        			fill (255,140,0);
	 		        			rect(min1_G, (abs(i / kinect.getVideoImage().width)), 5, 5);
	 		        			
	 		    	        	
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width>=max1_G && i%kinect.getVideoImage().width<max1_G+150){
		 		        		max1_G = i%kinect.getVideoImage().width;
		 		        		flag_G = true;
		 		        		
		 		        		fill (255,140,0);
	 		        			rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 5);
	 		        			//System.out.println ("1 "+max1_G);
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width<max1_G-150 && data[i]!=2047){
	 		        			max1_G = i%kinect.getVideoImage().width;
	 		        			flag_G = true;
	 		        			
	 		        			fill (255,140,0);
	 		        			rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 5, 5);
	 		        			//System.out.println ("2 "+max1_G);
	 		        		}
 		        		
 		        	}
 		        	
 		        	
		        	
		        	
		        	}
	        	}
	        	
	        	noStroke();
	        	   
		          
		        }
		      
		        
	      }
	      
	      if (j==3){
	    	  //System.out.println(height_R1+" "+height_G1+" "+height_B1+" "+height_Y1);
	      }
	        //}
	        	
	        	//**************************************************************
	        	// finding end point of first block
	        	//**************************************************************
	      
	     
	      
	    //   *end of finding ending point of first block
      	//**************************************************************
	      
	      
	    //**************************************************************
      	// finding starting point of second block
      	//**************************************************************
      		
	      if (height_B1 > 400 && height_R1 >400 && height_Y1 >400 && height_G1 >400)
	  		  fell_1 = true;
	      else
	    	  fell_1 = false;
	    
	      for (int i = 0; i < numPixels; i++)
	      {
	    	  
	    	//System.out.println(i+" "+data[i]);
	        //colouredPixels[abs(i / vidW)][i % vidW] = 0;
	        colouredPixels[abs(i / kinect.getVideoImage().width)][i % kinect.getVideoImage().width] = 0;
	        int currColor = kinect.getVideoImage().pixels[i]; //??
	        currR = (currColor >> 16) & 0xFF;
	        currG = (currColor >> 8) & 0xFF;
	        currB = currColor & 0xFF;
	        
	        
	        
	        
	        if(j==0){
	        	endpoint_firstblock = max1_R;
	        	
	        }
	        
	        if(j==1)
	        	endpoint_firstblock = max1_B;
	        
	        if(j==2){
	        	endpoint_firstblock = max1_Y;
	        	//System.out.println("endpoint "+endpoint_firstblock);
	        }
	        
	        if(j==3)
	        	endpoint_firstblock = max1_G;
	        
	        if (i%kinect.getVideoImage().width==0){
    			if(j==0){
    				flag_R = false;
    				flag2_R = false;
    			}
    			if(j==1){
    				flag_B = false;
    				flag2_B = false;
    			}
    			if(j==2){
    				flag_Y = false;
    				flag2_Y = false;
    			}
    			if(j==3){
    				flag_G = false;
    				flag2_G = false;
    			}
    			
    			if(j==0){
    				flag_min1R_found = false;
    				flag_min2R_found = false;
    				//System.out.println(flag_min1R_found+" "+i);
    			}
    			
    			if(j==1){
    				flag_min1B_found = false;
    				flag_min2B_found = false;
    			}
    			if(j==2){
    				flag_min1Y_found = false;
    				flag_min2Y_found = false;
    			}
    			if(j==3){
    				flag_min1G_found = false;
    				flag_min2G_found = false;
    			}
	        }
	        
	        if( isShowPixels && abs(i / kinect.getVideoImage().width)>300 && i%kinect.getVideoImage().width > endpoint_firstblock+10) // && data[i]>500 && data[i]<700
	        {
	        	/////////////////////////////////////////
	        	
	        	if (j==0 ){
	        		//fill(0,0,0);
	        		//rect((i % kinect.getVideoImage().width), (abs(i / kinect.getVideoImage().width)), 1, 1);
	        	}
	        	
	        	if (j ==0 || j==1 || j==2 ||j==3){
	        		
	        		
		        	if (i>5*kinect.getVideoImage().width && i<kinect.getVideoImage().pixels.length-5*kinect.getVideoImage().width){
		        	
		        		int cntr = 0;
		        	
		        if (data[i]>500 && data[i]<750){
		        	currColor = kinect.getVideoImage().pixels[i+1];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+2];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+3];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+4];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+5];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+2*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+3*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+4*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i+5*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-1];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-2];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-3];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-4];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-5];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-2*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-3*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-4*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        	
		        	currColor = kinect.getVideoImage().pixels[i-5*kinect.getVideoImage().width];
		        	currR = (currColor >> 16) & 0xFF;
			        currG = (currColor >> 8) & 0xFF;
			        currB = currColor & 0xFF;
		        	if (isColourWithinRange(j))
		        		cntr++;
		        }
		        	
		        	
		        	//if(i%kinect.getVideoImage().width < min1_G)
	        			//min1_G = i%kinect.getVideoImage().width;
		        	
		        	//System.out.println(i%kinect.getVideoImage().width);
		        	
		        	if (cntr>15){
		        		
		        		
		        		if (j == 0){//red
		        			if(i%kinect.getVideoImage().width < min2_R){
			        			min2_R = i%kinect.getVideoImage().width;
			        			flag_min2R_found = true;
			        			//System.out.println("min2 foundddddddd " + i%kinect.getVideoImage().width);
			        			if(abs(i / kinect.getVideoImage().width) > height_R2)
			        				height_R2=(abs(i / kinect.getVideoImage().width));	
		        			}
		        			
		        			if(abs(i%kinect.getVideoImage().width - min2_R)<20)
		        				flag_min2R_found = true;
		        			
		        			
		        			
		        		}
		        		
		        		if (j == 1){//blue
		        			if(i%kinect.getVideoImage().width < min2_B){
			        			min2_B = i%kinect.getVideoImage().width;
			        			flag_min2B_found = true;
			        			
			        			if(abs(i / kinect.getVideoImage().width) > height_B2)
			        				height_B2=(abs(i / kinect.getVideoImage().width));
			        			//System.out.println("min foundddddddd " + i%kinect.getVideoImage().width);
		        			}
		        			if(abs(i%kinect.getVideoImage().width - min2_B)<20)
		        				flag_min2B_found = true;
		        		}
		        		
		        		if (j == 2){//yellow
		        			if(i%kinect.getVideoImage().width < min2_Y){
			        			min2_Y = i%kinect.getVideoImage().width;
			        			flag_min2Y_found = true;
			        			
			        			if(abs(i / kinect.getVideoImage().width) > height_Y2)
			        				height_Y2=(abs(i / kinect.getVideoImage().width));
			        			//System.out.println("min foundddddddd " + i%kinect.getVideoImage().width);
		        			}
		        			if(abs(i%kinect.getVideoImage().width - min2_Y)<20)
		        				flag_min2Y_found = true;
		        		}
		        		
		        		if (j == 3){//green
		        			if(i%kinect.getVideoImage().width < min2_G){
			        			min2_G = i%kinect.getVideoImage().width;
			        			flag_min2G_found = true;
			        			if(abs(i / kinect.getVideoImage().width) > height_G2)
			        				height_G2=(abs(i / kinect.getVideoImage().width));
			        			//System.out.println("min foundddddddd " + i%kinect.getVideoImage().width);
		        			}
		        			
		        			if(abs(i%kinect.getVideoImage().width - min2_G)<20)
		        				flag_min2G_found = true;
		        		}
		        		
		        			
		        		
		        	}
		        	
		        		
		        	//red	
		        	if (j==0 && cntr==0 && i%kinect.getVideoImage().width > min2_R && flag2_R == false && flag_min2R_found == true){
		        		
		        	
	 		        		if(max2_R == 0 ){
	 		        			max2_R = min2_R;
	 		        			
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width>=max2_R){
		 		        		max2_R = i%kinect.getVideoImage().width;
		 		        		flag2_R = true;
		 		        		
	 		        		}
	 		        		
 		        		
		        	}
		        	
		        	//blue
		        	if (j==1 && cntr==0 && i%kinect.getVideoImage().width > min2_B && flag2_B == false && flag_min2B_found == true){
		        		
		        		
	 		        		if(max2_B == 0){
	 		        			max2_B = min2_B;
	 		        			
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width>=max2_B){
		 		        		max2_B = i%kinect.getVideoImage().width;
		 		        		flag2_B = true;
		 		        		
	 		        		}
	 		        		
 		        		
		        	}
		        	
		        	//yellow
		        	if (j==2 && cntr==0 && i%kinect.getVideoImage().width > min2_Y && flag2_Y == false && flag_min2Y_found == true){
		        		
		        		
	 		        		if(max2_Y == 0 ){
	 		        			max2_Y = min2_Y;
	 		        			
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width>=max2_Y ){
		 		        		max2_Y = i%kinect.getVideoImage().width;
		 		        		flag2_Y = true;
		 		        		
	 		        		}
	 		        		
 		        		
		        	}
		        	
		        	//green
		        	if (j==3 && cntr==0 && i%kinect.getVideoImage().width > min2_G && flag2_G == false && flag_min2G_found == true){
		        		
		        		
	 		        		if(max2_G == 0 ){
	 		        			max2_G = min2_G;
	 		        			
	 		        		}
	 		        		
	 		        		if (i%kinect.getVideoImage().width>=max2_G ){
		 		        		max2_G = i%kinect.getVideoImage().width;
		 		        		flag2_G = true;
		 		        		
	 		        		}
	 		        		
 		        		
		        	}
		        	
		        	
		        	
		        	
		        	}
	        	}
	        	
	        	noStroke();
	        	
		          
		          
		          
		          
		          
		        }
		        
		        
	      }
	      
	      if (height_B2 > 400 && height_R2 >400 && height_Y2 >400 && height_G2 >400){
	  		  fell_2 = true;
	  		  //System.out.println("fell_2 true");
	      }
	      else
	    	  fell_2 = false;
	      
	      
	      ////////////////////////////////////////////
	      ///////// end of finding starting pt of second block
	      
	     	//**************************************************************
      	// finding end point of second block
      	//**************************************************************
      		
      	/////////////////////////////////////////
	     
    
    	height_set = true;
	    }//end of first time 

	      
	      //width_R2 = 50;
	      //width_B2 = 50;
	      //width_G2 = 50;
	      //width_Y2 = 50;
	      
	 
    if (j == 0 ){//red
  	  
  	  if (max2_R - min2_R > width_R2 )
  		  width_R2 = max2_R - min2_R;
  	  
  	  //System.out.println("red "+ min2_R+" "+max2_R+" "+width_R1);
  	  fill(255,0,0);
  	  //if (fell_2 == true)
		//  fill (20,0,20);
  	rect(min2_R+150,height_R2-50,width_R2,50);
  	  rect(min2_R+850,height_R2-200,width_R2,50);
  	//System.out.println("min/max R2 drawing "+min2_R+" "+max2_R+" "+width_R2);
  	  //System.out.println("max2_R is: "+ max2_R);
    }
    
    //System.out.println(min1_R + " "+max1_R);
    
    if (j == 1){//blue
    	
    	
  	  if (max2_B - min2_B > width_B2 )
  		  width_B2 = max2_B - min2_B;
  	  
  	  //System.out.println("blue "+ min2_B+" "+max2_B+" "+width_B1);
  	  
  	  //System.out.println(width_R2);
  	  
  	  fill(0,0,255);
  	 // if (fell_2 == true)
		//  fill (20,0,20);
  	  rect(min2_B+150,height_B2-50,width_B2,50);
  	rect(min2_B+850,height_B2-200,width_B2,50);
  	//System.out.println("min/max B2 "+min2_B+" "+max2_B+" "+width_B2);
    }
    if (j == 2){//yellow
    	
    	
  	  if (max2_Y - min2_Y > width_Y2 )
  		  width_Y2 = max2_Y - min2_Y;
  	  
  	 //System.out.println("yellow "+ min2_Y+" "+max2_Y+" "+width_Y1);
	  
  	  
  	  //System.out.println(width_Y2);

  	  fill(255,255,0);
  	  //if (fell_2 == true)
		//  fill (20,0,20);
  	  rect(min2_Y+150,height_Y2-50,width_Y2,50);
  	rect(min2_Y+850,height_Y2-200,width_Y2,50);
  	//System.out.println("min/max Y2 "+min2_Y+" "+max2_Y+" "+width_Y2);
    }
    if (j == 3){//green
  	  
  	  if (max2_G - min2_G > width_G2 )
  		  width_G2 = max2_G - min2_G;
  	  
  	//System.out.println("green "+ min2_G+" "+max2_G+" "+width_G1);
  	  
  	  //System.out.println(width_G2);

  	  fill(0,255,0);
  	  
  	//if (fell_2 == true)
		//  fill (20,0,20);
  	
  	  rect(min2_G+150,height_G2-50,width_G2,50);
  	rect(min2_G+850,height_G2-200,width_G2,50);
  	  
  	if (fell_1 == true && fell_2==true){
  		//System.out.println ("both fell");
  		both_fell = true;
  		left_fell = false;
  		right_fell = false;
  	}
  		
  	else if (fell_2 == true){
		  fill (20,0,20);
	
	  rect(min2_G+150,height_G2-50,width_G2,150);
	  
	  if (state_GUI==3)
		  state_GUI = 4;
	  
	  //System.out.println ("right fell first");
	  right_fell = true;
	  left_fell = false;
	  both_fell = false;
	}
  	else if (fell_1 == true){
		  
	  
	  //System.out.println ("left fell first");
	  left_fell = true;
	  right_fell = false;
	  both_fell = false;
	}
  	else {
  	  
  	  left_fell = false;
  	  right_fell = false;
  	  both_fell = false;
  		
  	}
	  
  	  
  	  
  	//System.out.println("min/max G2 "+min2_G+" "+max2_G+" "+width_G2);
	  
    }
    
    
	 
	 //System.out.println(min1_R+" "+max1_R+" "+width_R1);
	 
    
    
  //   *end of finding ending point of second block
	//**************************************************************
    
    
	 if (j == 0){//red
	  	  
	  	  if (max1_R - min1_R > width_R1 )
	  		  width_R1 = max1_R - min1_R;
	  	  
	  	  //System.out.println("min/max R1 "+min1_R+" "+max1_R+" "+width_R1);
	  	  
	  	  fill(255,0,0);
	  	  
	  	// first block fell down  
	  
	  	if (fell_1 == true)
			 fill (20,0,20);
	  	
	  	rect(min1_R-150,height_R1-50,width_R1,50);
	  	  rect(min1_R+850,height_R1-200,width_R1,50);
	  	 
	  	  //System.out.println("height "+ height_R1);
	    }
	    
	    //System.out.println(min1_R + " "+max1_R);
	    
	    if (j == 1){//blue
	  	  
	  	  if (max1_B - min1_B > width_B1 )
	  		  width_B1 = max1_B - min1_B;
	  	  
	  	  //System.out.println(width_R1);
	  	  
	  	  fill(0,0,255);
	  	  
	  	if (fell_1 == true)
			 fill (20,0,20);
	  	  
	  	  rect(min1_B-150,height_B1-50,width_B1,50);
	  	rect(min1_B+850,height_B1-200,width_B1,50);
	  	  
	  	//System.out.println("min/max B1 "+min1_B+" "+max1_B+" "+width_B1);
	  	  //System.out.println(height_R1+" "+height_B1+" "+height_G1+" "+height_Y1);
	  	  
	    }
	    if (j == 2){//yellow
	  	  
	  	  if (max1_Y - min1_Y > width_Y1 )
	  		  width_Y1 = max1_Y - min1_Y;
	  	  
	  	  //System.out.println(width_Y1);

	  	  fill(255,255,0);
	  	  
	  	  
	  	  
	  	if (fell_1 == true)
			  fill (20,0,20);
	  	
	  	  rect(min1_Y-150,height_Y1-50,width_Y1,50);
	  	rect(min1_Y+850,height_Y1-200,width_Y1,50);
	  	  
	  	//System.out.println("min/max Y1 "+min1_Y+" "+max1_Y+" "+width_Y1);
	  	  
	  	
		
	    }
	    if (j == 3){//green
	    	
	    	
	  	
	  	  //System.out.println(width_G1);

	    	 if (max1_G - min1_G > width_G1 )
		  		  width_G1 = max1_G - min1_G;
		  	  
		  	  //System.out.println(width_Y1);

		  	  fill(0,255,0);
		  	  
		  	 
		  	rect(min1_G-150,height_G1-50,width_G1,50);
		  	rect(min1_G+850,height_G1-200,width_G1,50);
		  	  
		  	if (fell_1 == true){
				  fill (20,0,20);
		  	
		  	  rect(min1_G-150,height_G1-50,width_G1,150);
		  	  //state_GUI = 3;
		  	}
		  	  
	  	  
	  	//System.out.println("min/max G1 "+min1_G+" "+max1_G+" "+width_G1);
	  	  
	  	  
	    }  
	      
	      
         
	    }
	    
	    

	    for (int i = 0; i < coloursAssigned; i++)
	    {
	      centrePoints[i][0] = (squareCoords[i][0] * rectDivide) + ((squareCoords[i][2] * rectDivide) / 2);
	      centrePoints[i][1] = (squareCoords[i][1] * rectDivide) + ((squareCoords[i][3] * rectDivide) / 2);
	      //fill(0, 0, 0);
	      //ellipse(centrePoints[i][0], centrePoints[i][1], 10, 10);
	    }
	    
	    
	    
	    
	  } // update

	  boolean isColourWithinRange(int j)
	  {
		  
		  R = currR;
		  G = currG;
		  B = currB;
		  V = (0.439 * R) - (0.368 * G) - (0.071 * B) + 128;
		  U = -(0.148 * R) - (0.291 * G) + (0.439 * B) + 128;
		  
		  //if (compareUmin!=128)
			//  System.out.println(compareUmin+" "+compareVmin+" "+compareUmax+" "+compareVmax);
		
		if (j ==0)  
		    if(U < (maxCalibUR + 10) && U > (minCalibUR - 10) && V < (maxCalibVR + 10) && V > (minCalibVR - 10))
		    {
		    	//System.out.println(compareUmin+" "+compareVmin+" "+compareUmax+" "+compareVmax);
		      return true;
		    }
		
		if (j ==1)  
		    if(U < (maxCalibUB + 10) && U > (minCalibUB - 10) && V < (maxCalibVB + 10) && V > (minCalibVB - 10))
		    {
		    	//System.out.println(compareUmin+" "+compareVmin+" "+compareUmax+" "+compareVmax);
		      return true;
		    }
		
		if (j ==2)  
		    if(U < (maxCalibUY + 10) && U > (minCalibUY - 10) && V < (maxCalibVY + 10) && V > (minCalibVY - 10))
		    {
		    	//System.out.println(compareUmin+" "+compareVmin+" "+compareUmax+" "+compareVmax);
		      return true;
		    }
		
		if (j ==3)  
		    if(U < (maxCalibUG + 10) && U > (minCalibUG - 10) && V < (maxCalibVG + 10) && V > (minCalibVG - 10))
		    {
		    	//System.out.println(compareUmin+" "+compareVmin+" "+compareUmax+" "+compareVmax);
		      return true;
		    }
	    
		  
		  
		  /*
		  if (R<colourCompareDataMax[j][0]+15 && G<colourCompareDataMax[j][1]+15 && B<colourCompareDataMax[j][2]+15 && R>colourCompareDataMin[j][0]-15 && G>colourCompareDataMin[j][1]-15 && B>colourCompareDataMin[j][2]-15 ){
			  //if (j==0)
				//  System.out.println("reddd "+colourCompareDataMax[1][0]+" "+colourCompareDataMax[1][1]+" "+colourCompareDataMax[1][2]);
			  //if (j==1)
				//  System.out.println("bluee");
			  
			  return true;
		  }
		  */
	    
	    
	    return false;
	    
	    
	  }
	  
	  public void keyPressed(KeyEvent e) 
	  {
		  
		  int key = e.getKeyCode();
		  if (key == '2') 
		  {
			  
			  //AudioClip ac = getAudioClip(getCodeBase(), "start.wav");
	  		  ac_start.play();   //play once
			  
			  screenLoaded = true;
			  
			  /*
			  System.out.println("R pressed");
			  width_R1 = 0;
			  width_G1 = 0;
			  width_B1 = 0;
			  width_Y1 = 0;
			  
			  width_R2 = 0;
			  width_G2 = 0;
			  width_B2 = 0;
			  width_Y2 = 0;
			  
			  	min1_G=650;
			    min1_R=650;
			    min1_B=650;
			    min1_Y=650;
			    
			    min2_G=650;
			    min2_R=650;
			    min2_B=650;
			    min2_Y=650;
			    
			    max1_R = 0;
			    max1_G = 0;
			    max1_B = 0;
			    max1_Y = 0;

			    max2_R = 0;
			    max2_G = 0;
			    max2_B = 0;
			    max2_Y = 0;
			    
			    button_pressed = true;
			  
			  entered_endpt1_red = 0;
			  entered_endpt1_green = 0;
			  entered_endpt1_blue = 0;
			  entered_endpt1_yellow = 0;
			  
			  entered_endpt2 = 0;
			  */
		  }
		  
		  if (key == KeyEvent.VK_DOWN) 
		  {
			  if (cursor_posY<kinect.getVideoImage().height)
				  cursor_posY+=5;
		  }
		  
		  if (key == KeyEvent.VK_UP) 
		  {
			  if (cursor_posY>0)
				  cursor_posY-=5;
		  }
		  
		  if (key == KeyEvent.VK_LEFT) 
		  {
			  if (cursor_posX>0)
				  cursor_posX-=5;
		  }
		  
		  if (key == KeyEvent.VK_RIGHT) 
		  {
			  if (cursor_posX<kinect.getVideoImage().width)
				  cursor_posX+=5;
		  }
		  
		  if (key == '1') 
		  {
			  screenLoaded = true;
			  
				  int calibColor = kinect.getVideoImage().pixels[kinect.getVideoImage().width*cursor_posY+cursor_posX]; //??
				  System.out.println("calib color: "+calibColor);
			      int calibR = (calibColor >> 16) & 0xFF;
			      int calibG = (calibColor >> 8) & 0xFF;
			      int calibB = calibColor & 0xFF;
			      
			      double calibV = (0.439 * calibR) - (0.368 * calibG) - (0.071 * calibB) + 128;
				  double calibU = -(0.148 * calibR) - (0.291 * calibG) + (0.439 * calibB) + 128;
				  
		      
			 System.out.println("input "+calibR);
			 
			 
			 System.out.println(colorToBeCalibrated);
		    
		    if(colorToBeCalibrated == 1){
		      min1_R = 650;
		      
		      if (entered1 == false){
		    		minCalibRed = 650;
		    		minCalibGreen = 650;
		    		minCalibBlue = 650;
		    		
		    		maxCalibRed = 0;
		    		maxCalibGreen = 0;
		    		maxCalibBlue = 0;
		    		
		    	}
		    	
		    	entered1=true;
		      
		      if (calibV < minCalibVR){
		    	  minCalibVR = calibV;
		    	  System.out.println ("min V is: "+minCalibVR);
		      }
		      
		      if (calibV > maxCalibVR){
		    	  maxCalibVR = calibV;
		    	  System.out.println ("max V is: "+maxCalibVR);
		      }
		      
		      if (calibU < minCalibUR){
		    	  minCalibUR = calibU;
		    	  System.out.println ("min U is: "+minCalibUR);
		      }
		      
		      if (calibU > maxCalibUR){
		    	  maxCalibUR = calibU;
		    	  System.out.println ("max U is: "+maxCalibUR);
		      }
		      
			  int res = kinect.getVideoImage().width*cursor_posY+cursor_posX;
			  //fill (255,255,255);
			  //rect(cursor_posX,cursor_posY,10,10);
			  System.out.println("V current: "+calibV+"U current: "+calibU+"max calib V: "+maxCalibVR+"min calib V: "+minCalibVR+"max calib U: "+maxCalibUR+"min calib U: "+minCalibUR);
			  System.out.println(cursor_posX+" "+cursor_posY+" "+ res);
		    }
			  
			//blue
		    
		    if(colorToBeCalibrated == 2){
		    	min1_B = 650;
		    	
		    	if (entered2 == false){
		    		minCalibRed = 650;
		    		minCalibGreen = 650;
		    		minCalibBlue = 650;
		    		
		    		maxCalibRed = 0;
		    		maxCalibGreen = 0;
		    		maxCalibBlue = 0;
		    		
		    		System.out.println("entered");
		    		
		    		entered2=true;
		    		
		    	}
		    	
		    	System.out.println("input 2 "+calibR);
		    	
		    	
			  coloursAssigned = 2;
			  if (minCalibVB==0 || calibV < minCalibVB)
		    	  minCalibVB = calibV;
		      
		      if (maxCalibVB==0 || calibV > maxCalibVB)
		    	  maxCalibVB = calibV;
		      
		      if (minCalibUB==0 || calibU < minCalibUB)
		    	  minCalibUB = calibU;
		      
		      if (maxCalibUB==0 || calibU > maxCalibUB)
		    	  maxCalibUB = calibU;
		      
		      
		      
			  colourCompareDataMin[1][0] = minCalibRed;
			  colourCompareDataMin[1][1] = minCalibGreen;
			  colourCompareDataMin[1][2] = minCalibBlue;
			  
			  colourCompareDataMax[1][0] = maxCalibRed;
			  colourCompareDataMax[1][1] = maxCalibGreen;
			  colourCompareDataMax[1][2] = maxCalibBlue;
			  colours[1] = new Color(calibR, calibG, calibB);
			  
			  System.out.println("blue max "+colourCompareDataMax[1][0]+" "+colourCompareDataMax[1][1]+" "+colourCompareDataMax[1][2]);
			  
		    }
			  
			  //yellow
		    
		    if(colorToBeCalibrated == 3){
		    	min1_Y = 650;
		    	
		    	if (entered3 == false){
		    		minCalibRed = 650;
		    		minCalibGreen = 650;
		    		minCalibBlue = 650;
		    		
		    		maxCalibRed = 0;
		    		maxCalibGreen = 0;
		    		maxCalibBlue = 0;
		    		
		    		entered3=true;
		    		
		    	}
		    	
		    	
		    	
			  coloursAssigned = 3;
			  if (minCalibVY==0 || calibV < minCalibVY)
		    	  minCalibVY = calibV;
		      
		      if (maxCalibVY==0 || calibV > maxCalibVY)
		    	  maxCalibVY = calibV;
		      
		      if (minCalibUY==0 || calibU < minCalibUY)
		    	  minCalibUY = calibU;
		      
		      if (maxCalibUY==0 || calibU > maxCalibUY)
		    	  maxCalibUY = calibU;
		      
		      
		      
			  colourCompareDataMin[2][0] = minCalibRed;
			  colourCompareDataMin[2][1] = minCalibGreen;
			  colourCompareDataMin[2][2] = minCalibBlue;
			  
			  colourCompareDataMax[2][0] = maxCalibRed;
			  colourCompareDataMax[2][1] = maxCalibGreen;
			  colourCompareDataMax[2][2] = maxCalibBlue;
			  colours[2] = new Color(calibR, calibG, calibB);
		    }
			  
			  //green
		    if(colorToBeCalibrated == 4){
		    	min1_G = 650;
		    	
		    	if (entered4 == false){
		    		minCalibRed = 650;
		    		minCalibGreen = 650;
		    		minCalibBlue = 650;
		    		
		    		maxCalibRed = 0;
		    		maxCalibGreen = 0;
		    		maxCalibBlue = 0;
		    		
		    		entered4=true;
		    		
		    	}
		    	
		    	
		    	
			  coloursAssigned = 4;
			  if (minCalibVG==0 || calibV < minCalibVG)
		    	  minCalibVG = calibV;
		      
		      if (maxCalibVG==0 || calibV > maxCalibVG)
		    	  maxCalibVG = calibV;
		      
		      if (minCalibUG==0 || calibU < minCalibUG)
		    	  minCalibUG = calibU;
		      
		      if (maxCalibUG==0 || calibU > maxCalibUG)
		    	  maxCalibUG = calibU;
		      
		      
			  colourCompareDataMin[3][0] = minCalibRed;
			  colourCompareDataMin[3][1] = minCalibGreen;
			  colourCompareDataMin[3][2] = minCalibBlue;
			  
			  colourCompareDataMax[3][0] = maxCalibRed;
			  colourCompareDataMax[3][1] = maxCalibGreen;
			  colourCompareDataMax[3][2] = maxCalibBlue;
			  colours[3] = new Color(calibR, calibG, calibB);
			  calibration_finished = true;
		    }
		    
		    calibrationCntr++;
		    colorToBeCalibrated = calibrationCntr/4+1;
		    
		    
		    
		  
		  }
		  
		  
	  }
	  
	
}

