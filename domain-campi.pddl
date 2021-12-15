(define (domain CAMPI)
    (:requirements :typing :adl)
    (:types
        aratro seminatore trattore contadino campo
    )
    (:predicates    
                (contad ?contadino - contadino) 
                (tra ?trattore - trattore)
                (tra-ara ?trattore - trattore)
                (tra-semina ?trattore - trattore)
                (field ?campo - campo)
                (plow ?aratro - aratro)
                (sower ?seminatore - seminatore)
                (connesso ?campo1 - campo ?campo2 - campo)
                (at ?elem - (either trattore aratro contadino seminatore)  ?campo - campo)
                (arato ?campo - campo)
                (seminato ?campo - campo)
                (annaffiato ?campo - campo)
                (attrezzato ?strumento - (either seminatore aratro) ?trattore - trattore)
                (haAttrezzo ?trattore - trattore)
                (aBordo ?contadino - contadino ?trattore - trattore)
    )
	(:action ara
			:parameters (?trattore - trattore ?aratro - aratro ?campo - campo ?contadino - contadino)
			:precondition (and  (tra ?trattore)
                          (tra-ara ?trattore)
                          (plow ?aratro)
                          (field ?campo)
			  (contad ?contadino)
                          (at ?trattore ?campo)
                          (aBordo ?contadino ?trattore) 
                          (attrezzato ?aratro ?trattore)
                        )
      :effect (arato ?campo)     
  )
  (:action semina
    :parameters (?trattore - trattore ?seminatore - seminatore ?campo - campo ?contadino - contadino)
    :precondition (and  (tra ?trattore)
                        (tra-semina ?trattore)
                        (sower ?seminatore)
                        (field ?campo)
			            (contad ?contadino)
                        (at ?trattore ?campo)
                        (aBordo ?contadino ?trattore)
                        (attrezzato ?seminatore ?trattore)
                        (arato ?campo)
                  )
    :effect (and (not (arato ?campo))
                 (seminato ?campo)
            )
  )
  (:action innaffia
    :parameters (?contadino - contadino ?campo - campo)
    :precondition (and (contad ?contadino)
                       (field ?campo)
                       (at ?contadino ?campo)
                       (seminato ?campo)
                  )
    :effect (and (not (seminato ?campo))
                 (annaffiato ?campo)
            )
  )
  (:action getOn
    :parameters (?contadino - contadino ?trattore - trattore ?campo - campo)
    :precondition (and (contad ?contadino)
                       (tra ?trattore)
                       (field ?campo)
                       (at ?contadino ?campo)
                       (at ?trattore ?campo)
                       ; Un contadino NON può essere su più trattori: quando
                       ; sale su un trattore non è più vero (at contadino campo),
                       ; quindi (at contadino campo) è vera SOLO se il contadino
                       ; si trova sul campo "a piedi" e non sopra un trattore
                  )
    :effect (and (not (at ?contadino ?campo))
                 (aBordo ?contadino ?trattore)
            )
  )
  (:action getOff
    :parameters (?contadino - contadino ?trattore - trattore ?campo - campo)
    :precondition (and (contad ?contadino)
                       (tra ?trattore)
                       (field ?campo)
                       (aBordo ?contadino ?trattore)
                       (at ?trattore ?campo)
                                         )
    :effect (and (at ?contadino ?campo)
                 (not (aBordo ?contadino ?trattore))
            )
  )

  (:action equipAratro
    :parameters (?aratro - aratro ?trattore - trattore ?contadino - contadino ?campo - campo)
    :precondition (and (plow ?aratro)
                       (tra ?trattore)
                       (tra-ara ?trattore)
                       (contad ?contadino)
                       (field ?campo)
                       (not (haAttrezzo ?trattore))
                       (at ?aratro ?campo) ;Se l'aratro è sul campo allora non è attaccato al trattore
                       (at ?trattore ?campo)
                       (at ?contadino ?campo) ;Se il contadino è sul campo allora non è sul trattore
                  )
    :effect (and (haAttrezzo ?trattore)
                 (attrezzato ?aratro ?trattore)
                 (not (at ?aratro ?campo))
                 ; Un aratro NON può essere su più trattori: quando
                 ; è aggangiato ad un trattore non è più vero (at aratro campo),
                 ; quindi (at aratro campo) è vera SOLO se l'aratro
                 ; si trova sul campo "da solo" e non agganciato ad un trattore
            )
  )
  (:action equipSeminatore
    :parameters (?seminatore - seminatore ?trattore - trattore ?contadino - contadino ?campo - campo)
    :precondition (and (sower ?seminatore)
                       (tra ?trattore)
                       (tra-semina ?trattore)
                       (contad ?contadino)
                       (field ?campo)
                       (not (haAttrezzo ?trattore))
                       (at ?seminatore ?campo) ;Se il seminatore è sul campo allora è libero
                       (at ?trattore ?campo)
                       (at ?contadino ?campo) ;Se il contadino è sul campo allora non è sul trattore
                  )
    :effect (and (haAttrezzo ?trattore)
                 (attrezzato ?seminatore ?trattore)
                 (not (at ?seminatore ?campo))
            )
  )
  (:action unequip
    :parameters (?strumento - (either seminatore aratro) ?trattore - trattore ?contadino - contadino ?campo - campo)
    :precondition (and
                       (tra ?trattore)
                       (field ?campo)
                       (contad ?contadino)
                       (attrezzato ?strumento ?trattore)
                       (at ?trattore ?campo)
                       (at ?contadino ?campo) ;Se il contadino è sul campo allora non è sul trattore
                  )
    :effect (and (not (haAttrezzo ?trattore))
                 (not (attrezzato ?strumento ?trattore))
                 (at ?strumento ?campo)
            )
  )
  (:action moveFarmer
    :parameters (?contadino - contadino ?campo1 - campo ?campo2 - campo)
    :precondition (and
                       (contad ?contadino)
                       (field ?campo1)
                       (field ?campo2)
                       (connesso ?campo1 ?campo2)
                       (at ?contadino ?campo1) ;Se il contadino è sul campo allora non è sul trattore
                  )
    :effect (and (not (at ?contadino ?campo1))
                 (at ?contadino ?campo2)
            )
  )
  (:action moveTractor
    :parameters (?trattore - trattore ?contadino - contadino ?campo1 - campo ?campo2 - campo)
    :precondition (and
                       (tra ?trattore)
                       (field ?campo1)
                       (field ?campo2)
                       (connesso ?campo1 ?campo2)
		       (contad ?contadino)
                       (at ?trattore ?campo1)
                       (aBordo ?contadino ?trattore)
                  )
    :effect (and (not (at ?trattore ?campo1))
                 (at ?trattore ?campo2)
            )
  )
)

; ASSUNZIONI NOSTRE
; - Si può innaffiare anche se su un campo ci sono trattori o strumenti
; - Non c'è limite di contadini sullo stesso trattore