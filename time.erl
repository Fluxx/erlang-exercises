-module (time).
-compile(export_all).

sweedish_date () ->
  {FullYear, Month, Day} = date(),
  [_, _ | Year] = integer_to_list(FullYear),
  Numbers = [list_to_integer(Year), Month, Day],
  lists:flatten(io_lib:format("~2.2.0w~2.2.0w~2.2.0w", Numbers)).
  