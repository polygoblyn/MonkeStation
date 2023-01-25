//Ghost orbit types:
/// Ghosts will orbit objects in a circle
#define GHOST_ORBIT_CIRCLE "circle"
/// Ghosts will orbit objects in a triangle
#define GHOST_ORBIT_TRIANGLE "triangle"
/// Ghosts will orbit objects in a hexagon
#define GHOST_ORBIT_HEXAGON "hexagon"
/// Ghosts will orbit objects in a square
#define GHOST_ORBIT_SQUARE "square"
/// Ghosts will orbit objects in a pentagon
#define GHOST_ORBIT_PENTAGON "pentagon"

//Ghost showing preferences:
#define GHOST_ACCS_NONE		1
#define GHOST_ACCS_DIR		50
#define GHOST_ACCS_FULL		100

/// The main player's ghost will display as a simple white ghost
#define GHOST_ACCS_NONE_NAME "Default sprites"
/// The main player's ghost will display as a transparent mob
#define GHOST_ACCS_DIR_NAME "Only directional sprites"
/// The main player's ghost will display as a transparent mob with clothing
#define GHOST_ACCS_FULL_NAME "Full accessories"

/// The default ghost display selection for the main player
#define GHOST_ACCS_DEFAULT_OPTION GHOST_ACCS_FULL

//So save files can be sanitized properly.
GLOBAL_LIST_INIT(ghost_accs_options, list(GHOST_ACCS_NONE, GHOST_ACCS_DIR, GHOST_ACCS_FULL))

#define GHOST_OTHERS_SIMPLE 			1
#define GHOST_OTHERS_DEFAULT_SPRITE		50
#define GHOST_OTHERS_THEIR_SETTING 		100

/// The other players ghosts will display as a simple white ghost
#define GHOST_OTHERS_SIMPLE_NAME 			"white ghost"
/// The other players ghosts will display as transparent mobs
#define GHOST_OTHERS_DEFAULT_SPRITE_NAME 	"default sprites"
/// The other players ghosts will display as transparent mobs with clothing
#define GHOST_OTHERS_THEIR_SETTING_NAME 	"their setting"

/// The default ghost display selection when viewing other players
#define GHOST_OTHERS_DEFAULT_OPTION			GHOST_OTHERS_THEIR_SETTING

/// A ghosts max view range if they are a BYOND guest or regular account
#define GHOST_MAX_VIEW_RANGE_DEFAULT 10
/// A ghosts max view range if they are a BYOND paid member account (P2W feature)
#define GHOST_MAX_VIEW_RANGE_MEMBER 14

GLOBAL_LIST_INIT(ghost_others_options, list(GHOST_OTHERS_SIMPLE, GHOST_OTHERS_DEFAULT_SPRITE, GHOST_OTHERS_THEIR_SETTING)) //Same as ghost_accs_options.

// DEADCHAT MESSAGE TYPES //
/// Deadchat notification for new players who join the round at arrivals
#define DEADCHAT_ARRIVALRATTLE "arrivalrattle"
/// Deadchat notification for players who die during the round
#define DEADCHAT_DEATHRATTLE "deathrattle"
/// Deadchat notification for when there is an AI law change
#define DEADCHAT_LAWCHANGE "lawchange"
/// Deadchat regular ghost chat
#define DEADCHAT_REGULAR "regular-deadchat"

/// Pictures taken by a camera will not display ghosts
#define CAMERA_NO_GHOSTS 0
/// Pictures taken by a camera will display ghosts in the photo
#define CAMERA_SEE_GHOSTS_BASIC 1
/// Pictures taken by a camera will display ghosts and their orbits
#define CAMERA_SEE_GHOSTS_ORBIT 2
