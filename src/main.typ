#import "lib/lib.typ": conf, hr
#show: conf

#set document(
  title: "Play",
  author: "Phoenix Mandala",
  date: none,
  description: "On the epistemology of play",
)

#outline() #hr

= Notes
#include "notes/mod.typ"

#include "chapters/mod.typ"

#bibliography("/src/lib/bib.yaml", style: "chicago-author-date")
