// SPDX-FileCopyrightText: 2018 Frank Hunleth, Mark Sebald
//
// SPDX-License-Identifier: Apache-2.0

#include "rgb_nif.h"
#include "driver_ws2812b_basic.h"

#define WS2812B_EACH_RESET_BIT_FRAME_LEN        512        /**< 512 */
#define WS2812B_LEN        48                               /**< 48 */
#define WS2812B_TEM_LEN        (WS2812B_EACH_RESET_BIT_FRAME_LEN * WS2812B_LEN) / 8                               /**< 48 */

struct WsNifPriv {
    ErlNifResourceType *ws_nif_res_type;
};

struct WsNifRes {
    struct NeoPixelConfig config_ws;
};

static uint32_t gs_rgb[WS2812B_LEN];                /**< rgb buffer */
static uint8_t gs_temp[WS2812B_TEM_LEN];              /**< temp buffer*/

static ERL_NIF_TERM atom_ok;
static ERL_NIF_TERM atom_error;
static ERL_NIF_TERM atom_true;
static ERL_NIF_TERM atom_false;
static ERL_NIF_TERM atom_mode;
static ERL_NIF_TERM atom_bits_per_word;
static ERL_NIF_TERM atom_speed_hz;
static ERL_NIF_TERM atom_delay_us;
static ERL_NIF_TERM atom_lsb_first;
static ERL_NIF_TERM atom_sw_lsb_first;

static void ws_dtor(ErlNifEnv *env, void *obj)
{

}

static int neo_pixel_load(ErlNifEnv *env, void **priv_data, ERL_NIF_TERM info)
{
#ifdef DEBUG
#ifdef LOG_PATH
    log_location = fopen(LOG_PATH, "w");
#endif
#endif
    debug("neo_pixel_load");

    struct WsNifPriv *priv = enif_alloc(sizeof(struct WsNifPriv));
    if (!priv) {
        error("Can't allocate ws priv");
        return 1;
    }

    priv->ws_nif_res_type = enif_open_resource_type(env, NULL, "ws_nif_res_type", ws_dtor, ERL_NIF_RT_CREATE, NULL);
    if (priv->ws_nif_res_type == NULL) {
        error("open WS NIF resource type failed");
        return 1;
    }

    atom_ok = enif_make_atom(env, "ok");
    atom_error = enif_make_atom(env, "error");
    atom_true = enif_make_atom(env, "true");
    atom_false = enif_make_atom(env, "false");
    atom_mode = enif_make_atom(env, "mode");
    atom_bits_per_word = enif_make_atom(env, "bits_per_word");
    atom_speed_hz = enif_make_atom(env, "speed_hz");
    atom_delay_us = enif_make_atom(env, "delay_us");
    atom_lsb_first = enif_make_atom(env, "lsb_first");
    atom_sw_lsb_first = enif_make_atom(env, "sw_lsb_first");

    *priv_data = priv;
    return 0;
}

static void neo_pixel_unload(ErlNifEnv *env, void *priv_data)
{
    debug("neo_pixel_unload");
    enif_free(priv_data);
}

static ERL_NIF_TERM init(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    struct WsNifPriv *priv = enif_priv_data(env);
    struct NeoPixelConfig config;
    memset(&config, 0, sizeof(config));

    debug("ws812x_open");
    
    char error_str[128];
    snprintf(error_str, sizeof(error_str), "ok");

    if(ws2812b_basic_init() != 0)
    {
        snprintf(error_str, sizeof(error_str), "error");
        return enif_make_tuple2(env, atom_error,
                                enif_make_atom(env, error_str));
    }

    struct WsNifRes *ws_nif_res = enif_alloc_resource(priv->ws_nif_res_type, sizeof(struct WsNifRes));
    ws_nif_res->config_ws = config;
    ERL_NIF_TERM res_term = enif_make_resource(env, ws_nif_res);

    // Elixir side owns the resource. Safe for NIF side to release it.
    enif_release_resource(ws_nif_res);

    return enif_make_tuple2(env, atom_ok, res_term);
}

static ERL_NIF_TERM write_rgb(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    struct WsNifPriv *priv = enif_priv_data(env);
    struct WsNifRes *res;
    
    uint32_t number;
    uint32_t color;
    uint32_t i;

    debug("ws_write");
    if (!enif_get_resource(env, argv[0], priv->ws_nif_res_type, (void **)&res) ||
            !enif_get_uint(env, argv[1], &number) ||
            !enif_get_uint(env, argv[2], &color))
        return enif_make_badarg(env);

    /* write color */
    for (i = 0; i < number; i++)
    {
        gs_rgb[i] = color;
    }

    if (ws2812b_basic_write(gs_rgb, number, gs_temp, WS2812B_TEM_LEN) != 0)
        return atom_error;

    return atom_ok;
}

static ERL_NIF_TERM deinit(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{

    debug("ws_close");

    if(ws2812b_basic_deinit() != 0)
    {
        return atom_error;
    }
    else
    {
        return atom_ok;
    }

}


static ErlNifFunc nif_funcs[] =
{
    {"init", 0, init, 0},
    {"write_rgb", 3, write_rgb, ERL_NIF_DIRTY_JOB_IO_BOUND},
    {"deinit", 0, deinit, 0}
};

ERL_NIF_INIT(Elixir.Circuits.RGB.Nif, nif_funcs, neo_pixel_load, NULL, NULL, neo_pixel_unload)
