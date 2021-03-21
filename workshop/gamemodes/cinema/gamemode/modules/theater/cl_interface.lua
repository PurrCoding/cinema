local THEATER_INTERFACE = [[
    if (!window.theater) {
        class TheaterController {

            get player() {
                return window.player;
            }

            setVolume(volume) {
                if (!!this.player) {
                    this.player.volume = volume / 100;
                }
            }

            seek(second) {
                if (!!this.player && !!this.player.currentTime) {
                    this.player.currentTime = second;
                }
            }

            sync(time) {
                if (!!this.player && !!this.player.currentTime && !!time) {

                    var current = this.player.currentTime;
                    if ((current !== null) &&
                        (Math.abs(time - current) > 5)) {
                        this.player.currentTime = time;
                    }
                }
            }

            enableHD(on) { }
        };
        window.theater = new TheaterController();
    }
]]

module( "theater", package.seeall )

function startController()

    local panel = ActivePanel()
    if IsValid(panel) then
        panel:QueueJavascript(THEATER_INTERFACE)

        -- Run it on the next Think
        timer.Simple(0, function()
            SetVolume( GetVolume() )
        end)
    end
end