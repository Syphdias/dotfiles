return {
  {
    "echasnovski/mini.indentscope",
    opts = {
      draw = {
        -- no delay and animation for indentation markers
        delay = 0,
        animation = require("mini.indentscope").gen_animation.none(),
      },
    },
  },
}
