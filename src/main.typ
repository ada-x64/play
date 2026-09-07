#import "lib/lib.typ": conf, hr
#show: conf

#set document(
  title: "Play",
  author: "Phoenix Mandala",
  date: none,
  description: "On the epistemology of play",
)

#outline() #hr

#title("Notes")
#include "notes/mod.typ"

#title("Essays")
#include "chapters/mod.typ"

#bibliography("bib.yaml", style: "chicago-author-date")
