#import "lib.typ": conf, hr
#show: conf

#set document(
  title: "Play",
  author: "Phoenix Mandala",
  date: none,
  description: "On the epistemology of play",
)

#outline() #hr

#include "notes/main.typ"
#hr

#include "chapters/1. defining play.typ"
#hr

#bibliography("bib.yaml", style: "chicago-author-date")
