package asset_man

import str "core:strings"
import rl "vendor:raylib"
import "core:fmt"
import "core:os"

Asset :: union {
    rl.Texture2D,
    rl.Music,
    rl.Sound,

}

Asset_types :: enum {
    texture,
    music,
    sound

}

asset_bank: map[string]Asset
error_sprite: rl.Texture2D

init_asset_man :: proc() {

    spritesheet := #load("../../assets/sprites/sprite_sheet.png")

    if !rl.IsTextureReady(error_sprite) {
        err_source := #load("../../assets/sprites/error_texture.png")
        err_img := rl.LoadImageFromMemory(".png", raw_data(err_source), i32(len(err_source)))
        defer rl.UnloadImage(err_img)
        error_sprite = rl.LoadTextureFromImage(err_img)
    }
    // fmt.println(spritesheet)

    sprite := rl.LoadImageFromMemory(".png", raw_data(spritesheet), i32(len(spritesheet)))
    defer rl.UnloadImage(sprite)

    asset_bank["sprite_sheet.png"] = rl.LoadTextureFromImage(sprite)

}

get_asset :: proc(asset_name: string) -> Asset {

    asset, ok := asset_bank[asset_name]
    fmt.println(asset_bank)

    if ok {
        return asset
    }

    fullpath: str.Builder
    str.builder_init(&fullpath)
    defer str.builder_destroy(&fullpath)

    path, err := os.get_executable_directory(context.temp_allocator)
    if err != nil {
        fmt.eprintln("Error while gettingg executable directory", err)
        return error_sprite
    }

    str.write_string(&fullpath, string(path))
    str.write_string(&fullpath, "assets/")

    dot_i := str.index(asset_name, ".")

    if dot_i < 0 {
        fmt.eprintfln("The asset [%s] does not have a file extension", asset_name)
    }

    extension := asset_name[dot_i:]
    asset_type: Asset_types

    switch extension {

    case ".png", ".jpeg" :
        str.write_string(&fullpath, "sprites/")
        asset_type = Asset_types.texture
    
    case ".wav":
        str.write_string(&fullpath, "sounds/")
        asset_type = Asset_types.sound

    case ".mp3":
        str.write_string(&fullpath, "musics/")
        asset_type = Asset_types.music

    case :
        fmt.eprintfln("The extension of the asset [%s] is not compatible", asset_name)
        return error_sprite
    }

    str.write_string(&fullpath, asset_name)

    path_c := str.to_cstring(&fullpath)

    if !rl.FileExists(path_c) {
        fmt.eprintfln("The file [%s] does not exist", path_c)
        return error_sprite
    }

    switch asset_type {
        case .texture:
            asset_bank[asset_name] = rl.LoadTexture(path_c)

        case .music:
            asset_bank[asset_name] = rl.LoadMusicStream(path_c)

        case .sound:
            asset_bank[asset_name] = rl.LoadSound(path_c)

    }

    return asset_bank[asset_name]

}

delete_asset :: proc(asset_name: string) {
    delete_key(&asset_bank, asset_name)
}

clear_assets :: proc() {

    for key, asset in asset_bank {
        switch v in asset {
        case rl.Texture2D:
            rl.UnloadTexture(v)
        case rl.Music:
            rl.UnloadMusicStream(v)
        case rl.Sound:
            rl.UnloadSound(v)
        }

        delete_key(&asset_bank, key)
    }

    delete(asset_bank)

}

