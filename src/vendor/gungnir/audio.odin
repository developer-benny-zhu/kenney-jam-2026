package gungnir

import "core:log"
import sdl "vendor:sdl3"
import "vendor:sdl3/mixer"


Audio_Play_Mode :: enum {
	Once,
	Loop,
}
Audio :: struct {
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

load_audio :: proc(file_path: cstring) -> Audio {
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

	return Audio{audio = audio, track = track}
}

destroy_audio :: proc(audio: Audio) {
	if audio.track != nil {
		mixer.DestroyTrack(audio.track)
	}

	if audio.audio != nil {
		mixer.DestroyAudio(audio.audio)
	}
}

play_audio :: proc(audio: Audio, $play_mode: Audio_Play_Mode) {
	if audio.track == nil {
		return
	}

	ok := mixer.SetTrackPlaybackPosition(audio.track, 0)
	when play_mode == .Once {
		ok = mixer.PlayTrack(audio.track, 0)
	}
	when play_mode == .Loop {
		ok = mixer.PlayTrack(audio.track, -1)
	}
}

stop_audio :: proc(audio: Audio) {
	if audio.track == nil {
		return
	}

	ok := mixer.StopTrack(audio.track, 0)
}

pause_audio :: proc(audio: Audio) {
	if audio.track == nil {
		return
	}

	ok := mixer.PauseTrack(audio.track)
}

resume_audio :: proc(audio: Audio) {
	if audio.track == nil {
		return
	}

	ok := mixer.ResumeTrack(audio.track)
}

is_audio_playing :: proc(audio: Audio) -> bool {
	if audio.track == nil {
		return false
	}

	return mixer.TrackPlaying(audio.track)
}

set_audio_volume :: proc(audio: Audio, volume: f32) {
	if audio.track == nil {
		return
	}
	ok := mixer.SetTrackGain(audio.track, volume)
}