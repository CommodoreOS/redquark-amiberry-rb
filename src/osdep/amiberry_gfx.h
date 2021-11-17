#pragma once
#include <SDL.h>

#define GUI_WIDTH  800
#define GUI_HEIGHT 600

#define DISPLAY_SIGNAL_SETUP 				1
#define DISPLAY_SIGNAL_SUBSHUTDOWN 			2
#define DISPLAY_SIGNAL_OPEN 				3
#define DISPLAY_SIGNAL_SHOW 				4
#define DISPLAY_SIGNAL_QUIT 				5

#if defined REDQUARK
#define DISPLAY_SIGNAL_GUI_OPEN 			6
#define DISPLAY_SIGNAL_GUI_SHOW 			7
#define DISPLAY_SIGNAL_PAINT                8
#endif

#ifdef USE_DISPMANX
#include <bcm_host.h>
extern DISPMANX_DISPLAY_HANDLE_T displayHandle;
extern DISPMANX_MODEINFO_T modeInfo;
extern DISPMANX_UPDATE_HANDLE_T updateHandle;
extern DISPMANX_ELEMENT_HANDLE_T blackscreen_element;
extern VC_RECT_T src_rect;
extern VC_RECT_T dst_rect;
extern VC_RECT_T blit_rect;
extern VC_RECT_T black_rect;
extern VC_IMAGE_TYPE_T rgb_mode;
extern void change_layer_number(int layer);
#else
extern SDL_Surface* screen;
extern SDL_Texture* texture;
extern SDL_Cursor* cursor;
extern SDL_Texture* gui_texture;
extern SDL_DisplayMode sdlMode;
extern const char* sdl_video_driver;
#endif
extern SDL_Renderer* renderer;
extern SDL_Window* sdl_window;
extern SDL_Surface* gui_screen;
extern SDL_Rect renderQuad;

extern void check_error_sdl(bool check, const char* message);
extern void toggle_fullscreen();
extern int redquark_screen_init();

#if defined REDQUARK
extern int savestate_then_quit;
extern int delay_savestate_frame;
extern char* screenshot_filename;
#endif // REDQUARK

extern void DX_Fill(int dstx, int dsty, int width, int height, uae_u32 color);
extern void update_win_fs_mode(struct uae_prefs* p);
