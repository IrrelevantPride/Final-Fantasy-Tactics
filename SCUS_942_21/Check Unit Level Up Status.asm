            # Check_Unit_Level_Up_Status(unit) -> leveledup : bool
            #
            # This function checks if a unit leveled up and levels up a unit by 1 if exp > 100 and level < 99.
            # Overall the same as the vanilla function just editted slightly to save 5 instructions (20 bytes).

            .label @Level_Up, 0x8005da10
            
                addiu   sp, sp, -20                         # 
                sw      ra, 16(sp)                          #
                sw      s0, 12(sp)                          #
                sw      s1, 8(sp)                           #

                lbu     v0, 0x21(a0)                        # exp = unit.exp
                lbu     s1, 0x22(a0)                        # level = unit.level
                
                sltiu   v0, v0, 100                         # 
                bne     v0, zero, end                       # if exp < 100: return False
                li      v0, 0                               #
                sltiu   v0, s1, 99                          # 
                beq     v0, zero, max_level                 # if level < 99:
                move    s0, a0                              #
                jal     @Level_Up                           #   Level_Up(unit, leveldown = False)
                li      a1, 0                               #
                li      v0, 1                               #   leveledup = True
                addiu   s1, s1, 1                           #   level += 1
                sb      zero, 0x21(s0)                      #   unit.exp = 0
                j       end                                 #   unit.level = level ; return True
                sb      s1, 0x22(s0)                        # 

max_level:      li      a0, 99                              # The return value 0 in v0 was set previously by the branch since the branch can only get here if v0 was 0
                sb      a0, 0x21(s0)                        # unit.exp = 99 ; return False

end:            lw      ra, 16(sp)                          # 
                lw      s0, 12(sp)                          # 
                lw      s1, 8(sp)                           # 
                jr      ra                                  # 
                addiu   sp, sp, 20                          # 