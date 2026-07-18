package gungnir

import "core:log"
import sdl "vendor:sdl3"
import "vendor:sdl3/mixer"

Sound :: struct {
	audio: ^mixer.Audio,
	track: ^mixer.Track,
}

global_mixer: ^mixer.Mixer

init_audio_device :: proc() {
	if !sdl.Init({.AUDIO}) {
		when ODIN_DEBUG {
			log.errorf("Failed to initialize SDL Audio: %s", sdl.GetError())
		}
		return
	}

	if !mixer.Init() {
		when ODIN_DEBUG {
			log.errorf("Failed to initialize SDL3_mixer: %s", sdl.GetError())
		}
		return
	}

	global_mixer = mixer.CreateMixerDevice(sdl.AUDIO_DEVICE_DEFAULT_PLAYBACK, nil)
	if global_mixer == nil {
		when ODIN_DEBUG {
			log.errorf("Failed to create mixer: %s", sdl.GetError())
		}
	}
}

close_audio_device :: proc() {
	if global_mixer != nil {
		mixer.DestroyMixer(global_mixer)
		global_mixer = nil
	}

	mixer.Quit()
	sdl.QuitSubSystem({.AUDIO})
}

load_sound :: proc(file_path: cstring) -> Sound {
	if global_mixer == nil {
		when ODIN_DEBUG {
			log.error("Audio device has not been initialized")
		}
		return {}
	}

	audio := mixer.LoadAudio(global_mixer, file_path, false)
	if audio == nil {
		when ODIN_DEBUG {
			log.errorf("Failed to load audio (%s): %s", file_path, sdl.GetError())
		}
		return {}
	}

	track := mixer.CreateTrack(global_mixer)
	if track == nil {
		when ODIN_DEBUG {
			log.errorf("Failed to create track for %s: %s", file_path, sdl.GetError())
		}
		mixer.DestroyAudio(audio)
		return {}
	}

	if !mixer.SetTrackAudio(track, audio) {
		when ODIN_DEBUG {
			log.errorf("Failed to assign audio to track for %s: %s", file_path, sdl.GetError())
		}
		mixer.DestroyTrack(track)
		mixer.DestroyAudio(audio)
		return {}
	}

	return Sound{audio = audio, track = track}
}

destroy_sound :: proc(sound: Sound) {
	if sound.track != nil {
		mixer.DestroyTrack(sound.track)
	}
	if sound.audio != nil {
		mixer.DestroyAudio(sound.audio)
	}
}

play_sound :: proc(sound: Sound) {
	if sound.track == nil do return

	ok := mixer.SetTrackPlaybackPosition(sound.track, 0)
	ok = mixer.PlayTrack(sound.track, 0)
}

is_sound_playing :: proc(sound: Sound) -> bool {
	if sound.track == nil do return false
	return mixer.TrackPlaying(sound.track)
}
