.org 0x80059ed4

        # Find_Free_Party_Index_and_Generate_Unit(unit_type)
        # This function finds an empty party slot and generates a new unit there.
        # This is used for the Soldier Office units, monsters hatched from eggs, and to generate Ramza.
        # Only takes one parameter, unit_type, to determine if the unit is a male, female, Ramza or monster
        # The vanilla function does this through two loops and wastes space because of that.
        # This function saves space by getting the unit index from the Find_Free_Party_Index and 
        # removing the extra loop.

            .label @Get_Party_Data_Pointer, 0x80059af0
            .label @Generate_Unit, 0x80059ffc

                addiu   sp, sp, -20                     # 
                sw      ra, 16(sp)                      # 
                sw      s0, 12(sp)                      # 
                sw      s1, 8(sp)                       # 
                move    s0, a0                          # unit_type = a0
                jal     @Find_Empty_Party_Index         # partyid = Find_Free_Party_Index(isguest = False)
                li      a0, 0                           # 
                li      v1, -1                          # 
                beq     v1, v0, end                     # if partyid == -1: return -1
                move    s1, v0                          # 
                jal     @Get_Party_Data_Pointer         # unit = Get_Party_Data_Pointer(partyid)
                move    a0, v0                          # 
                sb      zero, 3(v0)                     # unit.palette = 0
                sb      s1, 1(v0)                       # unit.partyid = partyid
                move    a0, v0                          # 
                jal     @Generate_Unit                  # Generate_Unit(unit, unit_type)
                move    a1, s0                          # 
                
end:            lw      ra, 16(sp)                      # 
                lw      s0, 12(sp)                      # 
                lw      s1, 8(sp)                       # 
                jr      ra                              # 
                addiu   sp, sp, 20                      # 