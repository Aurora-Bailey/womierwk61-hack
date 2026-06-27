#include QMK_KEYBOARD_H

/* Phase 3a validation keymap: 5x14 grid matching the probed matrix.
 * Each position corresponds directly to a matrix cell, so when you press a key and watch
 * `qmk console` matrix debug, the reported (row,col) should match the cell below.
 * KC_NO = matrix cell with no switch (per probing). Bottom row (row4) is the uncertain
 * part — verify/adjust column positions from the console output.
 */
enum layers { _BASE, _FN };

/* Auto-enable matrix debug so `qmk console` prints the scanned (row,col) for every press.
 * Remove once the matrix is confirmed. */
void keyboard_post_init_user(void) {
    debug_enable = true;
    debug_matrix = true;
}

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    /*        c0       c1      c2      c3      c4      c5      c6      c7      c8      c9      c10     c11     c12     c13   */
    [_BASE] = LAYOUT(
        KC_ESC,  KC_1,   KC_2,   KC_3,   KC_4,   KC_5,   KC_6,   KC_7,   KC_8,   KC_9,   KC_0,   KC_MINS,KC_EQL, KC_BSPC,
        KC_TAB,  KC_Q,   KC_W,   KC_E,   KC_R,   KC_T,   KC_Y,   KC_U,   KC_I,   KC_O,   KC_P,   KC_LBRC,KC_RBRC,KC_BSLS,
        KC_CAPS, KC_A,   KC_S,   KC_D,   KC_F,   KC_G,   KC_H,   KC_J,   KC_K,   KC_L,   KC_SCLN,KC_QUOT,KC_ENT, KC_NO,
        KC_LSFT, KC_Z,   KC_X,   KC_C,   KC_V,   KC_B,   KC_N,   KC_M,   KC_COMM,KC_DOT, KC_SLSH,KC_RSFT,KC_NO,  KC_NO,
        KC_LCTL, KC_LGUI,KC_LALT,KC_NO,  KC_NO,  KC_NO,  KC_SPC, KC_NO,  KC_NO,  KC_RALT,MO(_FN),KC_APP, KC_RCTL,KC_NO
    ),
    [_FN] = LAYOUT(
        KC_GRV,  KC_F1,  KC_F2,  KC_F3,  KC_F4,  KC_F5,  KC_F6,  KC_F7,  KC_F8,  KC_F9,  KC_F10, KC_F11, KC_F12, KC_DEL,
        _______, _______,_______,_______,_______,_______,_______,_______,_______,_______,_______,_______,_______,_______,
        _______, _______,_______,_______,_______,_______,_______,_______,_______,_______,_______,_______,_______,XXXXXXX,
        _______, _______,_______,_______,_______,_______,_______,_______,_______,_______,_______,_______,XXXXXXX,XXXXXXX,
        _______, _______,_______,XXXXXXX,XXXXXXX,XXXXXXX,_______,XXXXXXX,XXXXXXX,_______,_______,_______,_______,XXXXXXX
    ),
};
