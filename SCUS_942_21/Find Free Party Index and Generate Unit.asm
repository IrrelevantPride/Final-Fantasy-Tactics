.org 0x80059ed4

        # Find_Empty_Party_Slot()

            .label @Get_Party_Data_Pointer, 0x00059af0
            .label @Generate_Unit, 0x80059ffc

                addiu   sp, sp, -20                     # 
                sw      ra, 16(sp)                      # 
                sw      s0, 12(sp)                      # 
                sw      s1, 8(sp)                       # 
                move    s0, a0                          # unit_type = a0
                jal     @Find_Empty_Party_Index         # partyid = Find_Empty_Party_Slot(isguest = False)
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