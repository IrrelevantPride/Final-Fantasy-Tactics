.org 0x80059e18

            .label @Get_Party_Data_Pointer, 0x80059af0
            .label @Calculate_Zodiac_From_Birthday, 0x8005e5d8
            
                addiu   sp, sp, -32                     # 
                sw      ra, 28(sp)                      # 
                sw      s0, 24(sp)                      # 
                sw      s1, 20(sp)                      # 
                sw      s2, 16(sp)                      # 
                sw      s3, 12(sp)                      # 

                move    s0, a0                          # jobid = a0
                move    s1, a1                          # birthday = a1
                move    s2, a2                          # eggmod = a2
                
                jal     @Find_Free_Party_Index_and_Generate_Unit
                
                li      a0, 3                           # partyid = Find_Free_Party_Index_and_Generate_Unit(unit_type = 3)
                move    s3, v0                          # s2 = partyid 
                li      v0, -1                          #
                beq     v0, zero, end                   # if partyid == -1: return -1
                nop                                     #
                jal     @Get_Party_Data_Pointer         # unit = Get_Party_Data_Pointer(partyid)
                move    a0, s3                          # 
                lbu     a0, 4(v0)                       # gender = unit.gender
                sb      s0, 2(v0)                       # unit.jobid = jobid
                sb      s2, 0xd2(v0)                    # unit.eggmod = eggmod
                ori     a0, a0, 0x04                    # gender &= 0x04
                sb      a0, 4(v0)                       # unit.gender = gender
                andi    a0, s1, 0xffff                  # legalbirthday = birthday & 0xFFFF
                sltiu   v1, a0, 0x16e                   #
                bne     v1, zero, calculate_zodiac      # if not legalbirthday:
                move    s0, v0                          # s0 = unit
                li      a0, 1                           #   birthday = 1

calculate_zodiac:
                jal     @Calculate_Zodiac_From_Birthday # zodiac = Calculate_Zodiac_From_Birthday(birthday)
                nop                                     #
                sll     a0, v0, 4                       # zodiac *= 4
                andi    v0, s1, 0x100                   # lobirthday = birthday & 0x100
                srl     v0, v0, 8                       # lobirthday >>= 8
                addu    v0, v0, a0                      # zodiac += lobirthday
                sb      v0, 6(s0)                       # unit.zodiac = zodiac
                sb      s1, 5(s0)                       # unit.birthday = birthday
                move    v0, s3                          # return partyid

end:            lw      ra, 28(sp)                      # 
                lw      s0, 24(sp)                      # 
                lw      s1, 20(sp)                      # 
                lw      s2, 16(sp)                      # 
                lw      s3, 12(sp)                      # 
                jr      ra                              # 
                addiu   sp, sp, 32                      # 
