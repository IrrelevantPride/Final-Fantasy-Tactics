.org 0x80059d5c

            # FindEmptyPartySlot(isguest) -> partyindex
            # This routine searches through the party data by checking the party index (byte 0x01) for 0xFF and returning the first instance of 0xFF.
            # The vanilla routine does this through two loops and wastes space because of that.
            # The vanilla routine also stores a value of 0 in the address provided in r5. The higher functions should take care of this, and this rewrite
            # includes minor edits to the Save Unit to Party (80059bb0) and Get Free Party Slot Status (801c6000) to accommodate this change.
            # For non-guest units, the search is through party index 0 - 15, and for guest units the search is through 16 - 20.
            # This saves from 0x80059dcc - 0x80059e17 (19 instructions or 76 bytes) over the vanilla implementation.

            .label @Get_Party_Data_Pointer, 0x00059af0

                addiu   sp, sp, -20                         # 
                sw      ra, 16(sp)                          # 
                sw      s0, 12(sp)                          # 
                sw      s1, 8(sp)                           # 
                li      s0, 0                               # startIndex = 0 ; endIndex = 16
                beq     a0, zero, loop                      # if isguest:
                li      s1, 16                              # 
                li      s0, 16                              #   startIndex = 16
                li      s1, 20                              #   endIndex = 20
                                                            # for partyindex in range(startIndex, endIndex):
loop:           jal     @Get_Party_Data_Pointer             #   unit = Get_Unit_Party_Data(counter)
                move    a0, s0                              # 
                lbu     v0, 1(v0)                           #   unit.partyid
                li      v1, 0xff                            #
                beq     v0, v1, end                         #   if unit.partyid == 0xFF: return partyindex
                move    v0, s0
                
                addiu   s0, s0, 1                           #
                slt     v0, s0, s1                          #
                bne     v0, zero, loop                      #
                nop                                         #
                li      v0, -1                              # return -1
                
end:            lw      ra, 16(sp)                          # 
                lw      s0, 12(sp)                          # 
                lw      s1, 8(sp)                           # 
                jr      ra                                  # 
                addiu   sp, sp, 20                          # 