            # This will ensure compatibility with the new Find Free Party Index function.

                sb      zero, 3(a1)                         # unit.palette = 0 ; isguest = False
                jal     @Find_Empty_Party_Slot              # Find_Empty_Party_Slot(isguest)
                li      a0, 0                               # 
        