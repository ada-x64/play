// mod-ignore
#import "/src/lib/lib.typ": _cite, cite, conf, hr

/// "The aesthetic names..."
#let noe_aesthetic = quote(
  [
    The aesthetic names the ever-ongoing process of bringing what there is into an
    always fragile focus; it is the movement, always subject to second-guessing,
    from not seeing to seeing, or from seeing to seeing differently. The aesthetic
    is the  fragile, productive (but also entangled) enacting of our consciousness
    itself. [...] We organize ourselves [...] by representing ourselves by
    ourselves. This representing is fragile: it never evades the rivalry, the
    availability of the aspect shift, or the second guess. It is productive: it isn't
    the work of self-making and also world-making, for we change ourselves and change
    what is there for us in the very act. And it is entangled, for we do all this
    always against the background of the situations in which we find ourselves
    including, as it does, everything that has come before, including all our past
    self-representations.
  ],
  block: true,
  attribution: [#cite(<noeEntanglementHowArt2023a>, "222-223")],
)

/// "The essence of play is..."
#let hans_play_1 = [
  "The essence of play is its capacity to saturate virtually every aspect of our lives, though not continuously." #cite(<hansPlayWorld1981>, 2)
]
/// "The willingness to forego one's own territory... is the fundamental feature of play"
#let hans_play_2 = [
  "The willingness to forego one's own territory, to be willing to pass beyond what one knows one is capable of, is the fundamental feature of play." #cite(<hansPlayWorld1981>, 13)
]
/// foreproject and structure
#let hans_play_3 = [
  #quote(
    "Still, whereas play is free in the sense that there is no Being in which to ground it, it is also bound in two crucial senses: first the beginning of play is always necessarily connected to a foreproject, to a series of prejudgments that are at issue in the activity of play itself, that give an orientation for the play; and second, the result of play is a structure, a framework or order that has been confirmed by the play itself.",
    block: true,
    attribution: cite(<hansPlayWorld1981>, 10),
  )
]

/// Ecstatic vs violent desire
///
/// "The problem is how to reconcile production of desire -- or ecstatic desire
/// -- and consumption of desire -- or violent desire. "
///
/// Very much in the realm of Deleuze and Guattari, Derrida, Gadamer, Nietzsche,
/// Lacan (via D&G). This is chapter 3 of Hans. Key ideas: play as the production of
/// the Real (cf ch2) non-self, desiring-production, mimesis, unification of ecstasy
/// and violence, critique of D&G, critical-theoretical applications
#let hans_desire = quote(block: true, attribution: cite(<hansPlayWorld1981>, 81), [
  The problem is how to reconcile production of desire -- or ecstatic desire --
  and consumption of desire -- or violent desire. Structurally, they are
  reconciled by the fact that both lead to undifferentiation, to the loss of
  difference which in turn generates a new series of differences, and by the
  fact that both are also imitative processes. In the play of production,
  imitation is central, but it is the imitation of play itself that is the goal,
  and implicit in that desire to imitate play is also a willing suspension of
  difference. [...] One need not worry about imitation leading to identity, for
  identity itself is not possible. One's imitation is always a graft, so it is
  always an imitation with a difference[. ...] It is the connection of
  difference that provides the play, the production, and the graft, and it is
  this connection, openly conceded, that provides the difference between the two
  models we have been looking at.
])


- Passive vs active syntheses (p54, p56), play and the production of the Real (p54ff)
- The copper fitting metaphor (p58)  -- pragmatism
- Entanglement and fields of play (p59-60)
- Girard and the violence of mimesis; underscores violent desire (p64ff)
- Reconciliation of violence and ecstasis (p66) "Indeed as a qualitative experience they are identical; only the interpretation and the consequences differ." "When a Sade or a Bataille comes along, we either reject their work as beastly or nod and agree that there is something there and promptly forget about it." (p67)
- Ties to _The Birth of Tragedy,_ Appollonian, Dionysian, and Socratic conceptions (p67-72)
- Lack vs fullness as valid kinds of desire: (p72-74)
- Critical-theoretical analysis (p74-79), drifts into metaphysics (p79) (spacing/temporizing); on identity (personal identity, though maybe he also intends mathematical identity) (p80-81)
- Conclusion and summary (p81-84)


== Peter Cole - On Givenness
#let cole_on_givenness = [
  #linebreak()
  #set align(center)
  #block[
    #set align(left)
    #quote(block: true, attribution: _cite(<coleGivenness2017>), [
      What if givenness _isn't_ enough —\
      and the wind's slithering along my arm\
      is really a subtle summery alarm\
      trying to tell me something else,\
      and much rougher?\
                                    That worth, for instance,\
      depends on a violence of difference\
                                                  and therefore\
      inevitably lies at a certain distance\
      from the stuff of life and us?\
      That even givenness has to be taken\
      hold of,\
                    at least by a kind of frame—\
      if not a reaching for steeper comparison?\
      And here it is,\
                              as though it were kissing\
      the thinnest of skins on my arm, or name.
    ])
  ]
  #set align(left)
  #linebreak()
]

/// Game play vs ludic activities vs being playful
#let rules_of_play_def_play = quote(block: true, attribution: [#cite(<salentekinbasRulesPlayGame2004>, "?")])[
  + *Game Play:* the formalized, focused interaction that
    occurs when players follow the rules of a game in order to play
    it.
  + *Ludic activities:* non-game behaviors in which
    participants are "playing," such as two tussling animals or a
    group of children tossing a ball in a circle. Game play is a
    subset of ludic activities.
  + *Being playful:* the state of being in a playful state of
    mind, such as when a spirit of play is injected into some other
    action. This category includes both game play and ludic
    activities.
]


#let transformative_play = quote(
  "Transformative play is a special case of play that occurs when the free
movement of play alters the more rigid structure in which it takes shape. The
play doesn't just occupy and oppose the interstices of the system, but actually
transforms the space as a whole.",
  attribution: cite(<salentekinbasRulesPlayGame2004>, "p305"),
)
