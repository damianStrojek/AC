#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdio.h>

#define TRUE 1
#define FALSE 0

int red, green, blue, yellow;
unsigned long foreground, background;

XArc circle1 = {50, 50, 400, 400, 0, 360*64};
XArc circle2 = {510, 50, 400, 400, 0, 360*64};

XPoint mousePosition;

//*************************************************************************************************************************
//funkcja przydzielania kolorow

int AllocNamedColor(char *name, Display* display, Colormap colormap){
    XColor col;
    XParseColor(display, colormap, name, &col);
    XAllocColor(display, colormap, &col);
    return col.pixel;
  } 

//*************************************************************************************************************************
// inicjalizacja zmiennych globalnych okreslajacych kolory

int init_colors(Display* display, int screen_no, Colormap colormap){
  background = WhitePixel(display, screen_no);  //niech tlo bedzie biale
  foreground = BlackPixel(display, screen_no);  //niech ekran bedzie czarny
  red=AllocNamedColor("red", display, colormap);
  green=AllocNamedColor("green", display, colormap);
  blue=AllocNamedColor("blue", display, colormap);
  yellow=AllocNamedColor("yellow", display, colormap);
}

// Punkty do narysowania inicjalow
void initializePoints(XPoint punktyLewo[], XPoint punktyPrawo[]){
	int dxLewe = 200, dxPrawe = 650;
	int dy = 150;
  
  // Punkty lewo
  punktyLewo[0].x = dxLewe + 0;
	punktyLewo[0].y = dy + 0;

	punktyLewo[1].x = dxLewe + 0;
	punktyLewo[1].y = dy + 220;
  
	punktyLewo[2].x = dxLewe + 80;
	punktyLewo[2].y = dy + 220;

	punktyLewo[3].x = dxLewe + 120;
	punktyLewo[3].y = dy + 180;

	punktyLewo[4].x = dxLewe + 120;
	punktyLewo[4].y = dy + 40;

	punktyLewo[5].x = dxLewe + 80;
	punktyLewo[5].y = dy + 0;

	punktyLewo[6].x = dxLewe + 0;
	punktyLewo[6].y = dy + 0;

	punktyLewo[7].x = dxLewe + 20;
	punktyLewo[7].y = dy + 20;

	punktyLewo[8].x = dxLewe + 20;
	punktyLewo[8].y = dy + 200;

	punktyLewo[9].x = dxLewe + 70;
	punktyLewo[9].y = dy + 200;

	punktyLewo[10].x = dxLewe + 100;
	punktyLewo[10].y = dy + 170;

  punktyLewo[11].x = dxLewe + 100;
  punktyLewo[11].y = dy + 50;

  punktyLewo[12].x = dxLewe + 70;
  punktyLewo[12].y = dy + 20;

  punktyLewo[13].x = dxLewe + 20;
  punktyLewo[13].y = dy + 20;

  // Punkty Prawo
	punktyPrawo[0].x = dxPrawe + 120;
	punktyPrawo[0].y = dy + 60;

	punktyPrawo[1].x = dxPrawe + 120;
	punktyPrawo[1].y = dy + 20;

	punktyPrawo[2].x = dxPrawe + 100;
	punktyPrawo[2].y = dy + 0;

	punktyPrawo[3].x = dxPrawe + 20;
	punktyPrawo[3].y = dy + 0;

	punktyPrawo[4].x = dxPrawe + 0;
	punktyPrawo[4].y = dy + 20;

	punktyPrawo[5].x = dxPrawe + 0;
	punktyPrawo[5].y = dy + 100;

	punktyPrawo[6].x = dxPrawe + 20;
	punktyPrawo[6].y = dy + 120;

	punktyPrawo[7].x = dxPrawe + 80;
	punktyPrawo[7].y = dy + 120;

	punktyPrawo[8].x = dxPrawe + 100;
	punktyPrawo[8].y = dy + 140;

	punktyPrawo[9].x = dxPrawe + 100;
	punktyPrawo[9].y = dy + 180;

	punktyPrawo[10].x = dxPrawe + 80;
	punktyPrawo[10].y = dy + 200;

	punktyPrawo[11].x = dxPrawe + 40;
	punktyPrawo[11].y = dy + 200;

  punktyPrawo[12].x = dxPrawe + 20;
  punktyPrawo[12].y = dy + 180;

  punktyPrawo[13].x = dxPrawe + 20;
  punktyPrawo[13].y = dy + 160;

  punktyPrawo[14].x = dxPrawe + 0;
  punktyPrawo[14].y = dy + 160;

  punktyPrawo[15].x = dxPrawe + 0;
  punktyPrawo[15].y = dy + 200;

  punktyPrawo[16].x = dxPrawe + 20;
  punktyPrawo[16].y = dy + 220;

  punktyPrawo[17].x = dxPrawe + 100;
  punktyPrawo[17].y = dy + 220;

  punktyPrawo[18].x = dxPrawe + 120;
  punktyPrawo[18].y = dy + 200;

  punktyPrawo[19].x = dxPrawe + 120;
  punktyPrawo[19].y = dy + 120;

  punktyPrawo[20].x = dxPrawe + 100;
  punktyPrawo[20].y = dy + 100;

  punktyPrawo[21].x = dxPrawe + 40;
  punktyPrawo[21].y = dy + 100;

  punktyPrawo[22].x = dxPrawe + 20;
  punktyPrawo[22].y = dy + 80;

  punktyPrawo[23].x = dxPrawe + 20;
  punktyPrawo[23].y = dy + 40;

  punktyPrawo[24].x = dxPrawe + 40;
  punktyPrawo[24].y = dy + 20;

  punktyPrawo[25].x = dxPrawe + 80;
  punktyPrawo[25].y = dy + 20;

  punktyPrawo[26].x = dxPrawe + 100; 
  punktyPrawo[26].y = dy + 40;

  punktyPrawo[27].x = dxPrawe + 100;
  punktyPrawo[27].y = dy + 60;

  punktyPrawo[28].x = dxPrawe + 120;
  punktyPrawo[28].y = dy + 60;

  return;
};

void drawCircle(Display *d, Window w, GC gc, XArc circle, int color){
  XSetForeground(d, gc, color);
  XFillArc(d, w, gc, circle.x, circle.y, circle.width, circle.height, circle.angle1, circle.angle2*64);
}

void drawInitials(Display *d, Window w, GC gc, XPoint punktyLewo[], XPoint punktyPrawo[]){
  XSetForeground(d, gc, red);
  XFillPolygon(d, w, gc, punktyLewo, 14, Complex, CoordModeOrigin);
  XFillPolygon(d, w, gc, punktyPrawo, 29, Complex, CoordModeOrigin);
}

void move(XEvent event, XPoint punktyLewo[], XPoint punktyPrawo[]){
  int movementX = event.xbutton.x - mousePosition.x;
  int movementY = event.xbutton.y - mousePosition.y;

  // wzór na pole okregu, jezeli myszka znajduje sie w srodku to ma sie on poruszac razem z myszka
  if (((mousePosition.x-(circle1.x+circle1.width/2))*(mousePosition.x-(circle1.x+circle1.width/2))\
  + (mousePosition.y-(circle1.y+circle1.height/2))*(mousePosition.y-(circle1.y+circle1.height/2))) <= pow(circle1.width/2, 2)){ 
    
    circle1.x += movementX;
    circle1.y += movementY;
    
    for(int i = 0; i < 14; i++){
    	punktyLewo[i].x += movementX;
      punktyLewo[i].y += movementY;
    }
    
    mousePosition.x = event.xbutton.x;
    mousePosition.y = event.xbutton.y;
  }
  else if (((mousePosition.x-(circle2.x+circle2.width/2))*(mousePosition.x-(circle2.x+circle2.width/2))\
  + (mousePosition.y-(circle2.y+circle2.height/2))*(mousePosition.y-(circle2.y+circle2.height/2))) <= pow(circle2.width/2, 2)){

    circle2.x += movementX;
    circle2.y += movementY;

    for(int i = 0; i < 29; i++){
      punktyPrawo[i].x += movementX;
      punktyPrawo[i].y += movementY;
    }

    mousePosition.x = event.xbutton.x;
    mousePosition.y = event.xbutton.y;
  }
}

//*************************************************************************************************************************
// Glowna funkcja zawierajaca petle obslugujaca zdarzenia */

int main(int argc, char *argv[]){
  char            icon_name[] = "Grafika";
  char            title[]     = "Grafika komputerowa";
  Display*        display;    //gdzie bedziemy wysylac dane (do jakiego X servera)
  Window          window;     //nasze okno, gdzie bedziemy dokonywac roznych operacji
  GC              gc;         //tu znajduja sie informacje o parametrach graficznych
  XEvent          event;      //gdzie bedziemy zapisywac pojawiajace sie zdarzenia
  KeySym          key;        //informacja o stanie klawiatury 
  Colormap        colormap;
  int             screen_no;
  XSizeHints      info;       //informacje typu rozmiar i polozenie ok
  
  char            buffer[8];  //gdzie bedziemy zapamietywac znaki z klawiatury
  int             hm_keys;    //licznik klawiszy
  int             to_end;

  display    = XOpenDisplay("");                //otworz polaczenie z X serverem pobierz dane od zmiennej srodowiskowej DISPLAY ("")
  screen_no  = DefaultScreen(display);          //pobierz domyslny ekran dla tego wyswietlacza (0)
  colormap = XDefaultColormap(display, screen_no);
  init_colors(display, screen_no, colormap);

  // Wielokaty od inicjalow
  XPoint punktyLewo[14], punktyPrawo[29];
  initializePoints(punktyLewo, punktyPrawo);

  //okresl rozmiar i polozenie okna
  info.x = 100;
  info.y = 150;
  info.width = 1200;
  info.height = 600;
  info.flags = PPosition | PSize;

  //majac wyswietlacz, stworz okno - domyslny uchwyt okna
  window = XCreateSimpleWindow(display, DefaultRootWindow(display),info.x, info.y, info.width, info.height, 7/* grubosc ramki */, foreground, background);
  XSetStandardProperties(display, window, title, icon_name, None, argv, argc, &info);
  //utworz kontekst graficzny do zarzadzania parametrami graficznymi (0,0) domyslne wartosci
  gc = XCreateGC(display, window, 0, 0);
  XSetBackground(display, gc, background);
  XSetForeground(display, gc, foreground);

  //okresl zdarzenia jakie nas interesuja, np. nacisniecie klawisza
  XSelectInput(display, window, (KeyPressMask | ExposureMask | ButtonPressMask| ButtonReleaseMask | Button1MotionMask));
  XMapRaised(display, window);  //wyswietl nasze okno na samym wierzchu wszystkich okien
      
  to_end = FALSE;

  while (to_end == FALSE){
    drawCircle(display, window, gc, circle1, green);
    drawCircle(display, window, gc, circle2, blue);
    drawInitials(display, window, gc, punktyLewo, punktyPrawo);

    XNextEvent(display, &event);  // czekaj na zdarzenia okreslone wczesniej przez funkcje XSelectInput
    XClearWindow(display, window);

    switch(event.type){
      case Expose:
        if (event.xexpose.count == 0)
        {
         
        }
        break;

      case MappingNotify:
        XRefreshKeyboardMapping(&event.xmapping); // zmiana ukladu klawiatury - w celu zabezpieczenia sie przed taka zmiana trzeba to wykonac
        break;

      case ButtonPress:
        if (event.xbutton.button == Button1){
          mousePosition.x = event.xbutton.x;
          mousePosition.y = event.xbutton.y;   
          printf("%d %d\n", mousePosition.x, mousePosition.y);
        }
        break;


      case KeyPress:
        hm_keys = XLookupString(&event.xkey, buffer, 8, &key, 0);
        if (hm_keys == 1)
        {
          if (buffer[0] == 'q') to_end = TRUE;        // koniec programu
          
        }
              
      case MotionNotify:
      	printf("Motion: %d %d\n", event.xbutton.x, event.xbutton.y);
      	move(event, punktyLewo, punktyPrawo);

      default:
        break;
    }
  }

  XFreeGC(display, gc);
  XDestroyWindow(display, window);
  XCloseDisplay(display);

  return 0;
}
