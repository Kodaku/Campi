(define (domain CAMPI)

    ;per risolvere il  problema sono state stilate le seguenti azioni ->
            ;azione per muovere un contadino da un campo ad un altro
            ;azione per muovere un trattore da un campo ad un altro
            ;azione per far salire un contadino a bordo di un trattore
            ;azione per far scendere un contadino dal trattore
            ;azione per equipaggiare un trattore con un aratro
            ;azione per equipaggiare un trattore con un seminatore
            ;azione per rimuovere un equipaggiamento da un trattore 
            ;azione per arare un campo
            ;azione per seminare un campo
            ;azione per innaffiare un campo
            
            
    (:requirements :typing :adl)
    (:types
        aratro seminatore trattore contadino campo
    )
    (:predicates    
                (tractor ?trattore - trattore)
                (tractor-ara ?trattore - trattore)
                (tractor-semina ?trattore - trattore)
                (farmer ?contadino - contadino) 
                (field ?campo - campo)
                (connesso ?campo1 - campo ?campo2 - campo)
                (plow ?aratro - aratro)
                (sower ?seminatore - seminatore)
                (at ?elem - (either trattore aratro contadino seminatore)  ?campo - campo)
                (arato ?campo - campo)
                (seminato ?campo - campo)
                (annaffiato ?campo - campo)
                (attrezzato ?strumento - (either seminatore aratro) ?trattore - trattore)
                (haAttrezzo ?trattore - trattore)
                (aBordo ?contadino - contadino ?trattore - trattore)
    )
    
    ;azione per far muovere un contadino da un campo ad un altro
    (:action moveFarmer
      :parameters (?contadino - contadino ?campo1 - campo ?campo2 - campo)
      :precondition (and
                       (farmer ?contadino)
                       (field ?campo1)
                       (field ?campo2)
                       (at ?contadino ?campo1)
                       (connesso ?campo1 ?campo2)
                  )
      :effect (and (not (at ?contadino ?campo1))
                 (at ?contadino ?campo2)
            )
     )
     
     ;azione per muovere un trattore da un campo ad un altro
    (:action moveTractor
    :parameters (?trattore - trattore ?contadino - contadino ?campo1 - campo ?campo2 - campo)
    :precondition (and
                       (tractor ?trattore)
                       (field ?campo1)
                       (field ?campo2)
                       (at ?trattore ?campo1)
                       (connesso ?campo1 ?campo2)
		               (farmer ?contadino)
                       (aBordo ?contadino ?trattore)
                  )
      :effect (and (not (at ?trattore ?campo1))
                 (at ?trattore ?campo2)
            )
    )
    
    ;azione per far salire un contadino a bordo di un trattore (un contadino può stare su un campo oppure su un trattore)
    (:action getOn
        :parameters (?contadino - contadino ?trattore - trattore ?campo - campo)
        :precondition (and (farmer ?contadino)
                           (tractor ?trattore)
                           (field ?campo)
                           (at ?trattore ?campo)
                           (at ?contadino ?campo)
                        )
        :effect (and (not (at ?contadino ?campo))
                     (aBordo ?contadino ?trattore)
                )
      )
      
    ;azione per far scendere un contadino dal trattore
    (:action getOff
        :parameters (?contadino - contadino ?trattore - trattore ?campo - campo)
        :precondition (and (farmer ?contadino)
                           (tractor ?trattore)
                           (field ?campo)
                           (at ?trattore ?campo)
                           (aBordo ?contadino ?trattore)
                        )
        :effect (and (at ?contadino ?campo)
                     (not (aBordo ?contadino ?trattore))
            )
    )
    ;azione per equipaggiare un trattore con un aratro
    (:action equipAratro
    :parameters (?aratro - aratro ?trattore - trattore ?contadino - contadino ?campo - campo)
    :precondition (and (plow ?aratro)
                       (tractor ?trattore)
                       (tractor-ara ?trattore)
                       (field ?campo)
                       (farmer ?contadino)
                       (not (haAttrezzo ?trattore))
                       (at ?contadino ?campo) 
                       (at ?aratro ?campo) 
                       (at ?trattore ?campo)
                  )
    :effect (and (attrezzato ?aratro ?trattore)
                 (haAttrezzo ?trattore)
                 (not (at ?aratro ?campo))
            )
    )
    
    ;azione per equipaggiare un trattore con un seminatore
    (:action equipSeminatore
    :parameters (?seminatore - seminatore ?trattore - trattore ?contadino - contadino ?campo - campo)
    :precondition (and (sower ?seminatore)
                       (tractor ?trattore)
                       (tractor-semina ?trattore)
                       (field ?campo)
                       (farmer ?contadino)
                       (not (haAttrezzo ?trattore))
                       (at ?trattore ?campo)
                       (at ?contadino ?campo) 
                       (at ?seminatore ?campo) 
                       
                  )
    :effect (and (attrezzato ?seminatore ?trattore)
                 (haAttrezzo ?trattore)
                 (not (at ?seminatore ?campo))
            )
   )
    ;azione per rimuovere un equipaggiamento da un trattore 
    (:action unequip
     :parameters (?strumento - (either seminatore aratro) ?trattore - trattore ?contadino - contadino ?campo - campo)
     :precondition (and
                       (field ?campo)
                       (farmer ?contadino)
                       (tractor ?trattore)
                       (attrezzato ?strumento ?trattore)
                       (at ?contadino ?campo)
                       (at ?trattore ?campo)
                       
                  )
     :effect (and (not (attrezzato ?strumento ?trattore))
                 (not (haAttrezzo ?trattore))
                 (at ?strumento ?campo)
            )
    )
    
    ;azione per arare un campo 
	(:action ara
	 :parameters (?trattore - trattore ?aratro - aratro ?campo - campo ?contadino - contadino)
	 :precondition (and  
	                   (field ?campo)
	                   (farmer ?contadino)
    			       (tractor ?trattore)
                       (tractor-ara ?trattore)
                       (plow ?aratro)
                       (at ?trattore ?campo)
                       (attrezzato ?aratro ?trattore)
                       (aBordo ?contadino ?trattore) 
                       
                    )
      :effect (arato ?campo)     
  )
  ;azione per seminare un campo
  (:action semina
    :parameters (?trattore - trattore ?seminatore - seminatore ?campo - campo ?contadino - contadino)
    :precondition (and  
                        (field ?campo)
                        
                        (farmer ?contadino)
                        (tractor ?trattore)
                        (tractor-semina ?trattore)
                        (sower ?seminatore)
                        (at ?trattore ?campo)
                        (attrezzato ?seminatore ?trattore)
                        (arato ?campo)
                        (aBordo ?contadino ?trattore)
                  )
    :effect (and (seminato ?campo)
                 (not (arato ?campo))
            )
  )
  ;azione per innaffiare un campo
  (:action innaffia
    :parameters (?contadino - contadino ?campo - campo)
    :precondition (and 
                       (field ?campo)
                       (farmer ?contadino)
                       (at ?contadino ?campo)
                       (seminato ?campo)
                  )
    :effect (and (annaffiato ?campo)
                 (not (seminato ?campo))
            )
  )

)
