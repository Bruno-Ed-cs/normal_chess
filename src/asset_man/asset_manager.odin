package asset_man

import str "core:strings"
import rl "vendor:raylib"
import "core:fmt"

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

get_asset :: proc(asset_name: string) -> Asset {

    asset, ok := asset_bank[asset_name]

    if ok {
        return asset
    }


    fullpath: str.Builder
    str.builder_init(&fullpath)
    defer str.builder_destroy(&fullpath)

    str.write_string(&fullpath, string(rl.GetApplicationDirectory()))
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
    }

    str.write_string(&fullpath, asset_name)

    path := str.to_cstring(&fullpath)

    if !rl.FileExists(path) {
        fmt.eprintfln("The file [%s] does not exist", path)
        return asset
    }

    switch asset_type {
        case .texture:
            asset_bank[asset_name] = rl.LoadTexture(path)

        case .music:
            asset_bank[asset_name] = rl.LoadMusicStream(path)

        case .sound:
            asset_bank[asset_name] = rl.LoadSound(path)

    }

    return asset_bank[asset_name]

}

delete_asset :: proc(asset_name: string) 

delete_asset_bank :: proc()

