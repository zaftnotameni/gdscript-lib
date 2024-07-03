class_name Zaft_TitleMenuHandlers_Resource extends Resource

func warn(which:String):
  print_rich("[color=yellow]default behavior of Zaft Lib being used, you probably don't want this[/color]\n\
    to fix: give a [b]Zaft_TitleMenuHandlers_Resource[/b] to the main scene\n\
    it can implement [b]%s[/b] ([i]without[/i] calling [b]super[/b])" % which)
  pass

func on_test():
  warn("on_test")
func on_continue():
  warn("on_continue")
func on_start():
  warn("on_start")
func on_load():
  warn("on_load")
func on_options():
  warn("on_options")
func on_about():
  warn("on_about")
func on_exit():
  warn("on_exit")
  __zaft.path.main().get_tree().quit()
  pass

func connect_to_bus():
  __zaft.bus.title_screen.test_pressed.connect(on_test)
  __zaft.bus.title_screen.continue_pressed.connect(on_continue)
  __zaft.bus.title_screen.start_pressed.connect(on_start)
  __zaft.bus.title_screen.load_pressed.connect(on_load)
  __zaft.bus.title_screen.options_pressed.connect(on_options)
  __zaft.bus.title_screen.about_pressed.connect(on_about)
  __zaft.bus.title_screen.exit_pressed.connect(on_exit)

