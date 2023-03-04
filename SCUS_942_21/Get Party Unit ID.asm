            # Get_Party_Unit_ID(id) -> partyid
            
            .label @Party_Array, 0x80057f74

                li      t0, 0                               # index = 0
                li      t1, 0xff                            # 
                la      t2, @Party_Array                    # for unit in partyarray
check_partyid:  lbu     v0, 1(t2)                           #   partyid = unit.partyid
                lbu     v1, 0(t2)                           #   basejobid = unit.basejob
                beq     v0, t1, continue                    #   if partyid == 0xFF: break
                nop                                         # 
                beq     v1, a0, return                      #   if basejobid == id: return index
                move    v0, t0                              #   
continue:       addiu   t0, t0, 1                           #   index += 1
                slti    v0, t0, 20                          # 
                bne     v0, zero, check_partyid             # 
                addiu   t2, t2, 0x100                       # 
                li      v0, -1                              # return -1
return:         jr      ra                                  # 
                nop                                         # 