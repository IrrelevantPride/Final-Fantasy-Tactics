        # Remove_Unit_From_Party(partyid) -> None

        .label @Party_Array, 0x80057f74

                sll     a0, a0, 8                           # partyid * 8
                li      v0, 0xff                            # nullid = 0xFF
                la      v1, @Party_Array                    # 
                addu    a0, a0, v1                          # unit = Party_Array[partyid]
                jr      ra                                  # 
                sb      v0, 1(a0)                           # unit.partyid = nullid