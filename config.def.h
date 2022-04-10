/* user and group to drop privileges to */
static const char *user  = "merrinx";
static const char *group = "wheel";

static const char col_init[]            = "#282828";    // Dark
static const char col_input[]           = "#3c3836";    // Grey
static const char col_failed[]          = "#cc241d";    // Red
static const char *colorname[NUMCOLS]   = {
	[INIT]      = col_init,         /* after initialization */
	[INPUT]     = col_input,        /* during input */
	[FAILED]    = col_failed,       /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/*Enable blur*/
#define BLUR
/*Set blur radius*/
static const int blurRadius=5;
/*Enable Pixelation*/
//#define PIXELATION
/*Set pixelation radius*/
static const int pixelSize=0;
/* time in seconds before the monitor shuts down */
static const int monitortime = 10;
