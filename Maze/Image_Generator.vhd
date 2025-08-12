library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Image_Generator is
    Port (
        CLK     : in  STD_LOGIC;
        h_count : in  INTEGER;
        v_count : in  INTEGER;
        RED     : out STD_LOGIC_VECTOR (0 downto 0);
        GREEN   : out STD_LOGIC_VECTOR (0 downto 0);
        BLUE    : out STD_LOGIC_VECTOR (0 downto 0);
		  KEY_CODE    : in STD_LOGIC_VECTOR(7 downto 0);
		  KEY_PRESSED : in STD_LOGIC
    );
end Image_Generator;

architecture Behavioral of Image_Generator is
    constant H_ACTIVE : integer := 600;
    constant V_ACTIVE : integer := 440;

    constant BOX_WIDTH  : integer := 25;
    constant BOX_HEIGHT : integer := 25;

    signal pos_x : integer := 15;
    signal pos_y : integer := 15;

    signal move_counter : integer := 0;
    constant MOVE_DELAY : integer := -2000;

    signal goal_reached : boolean := false;

    constant GOAL_X : integer := 555;
    constant GOAL_Y : integer := 400;

    function is_wall(x, y: integer) return boolean is
        variable result : boolean := false;
    begin
        -- Zewnêtrzna ramka
        if x < 10 or x > 590 or y < 10 or y > 430 then
            result := true;
        end if;

        -- pionowe œciany
        if x >= 60 and x <= 65 and y >= 10 and y <= 100 then
            result := true;
        end if;

        if x >= 120 and x <= 125 and y >= 110 and y <= 430 then
            result := true;
        end if;

        if x >= 180 and x <= 185 and y >= 10 and y <= 200 then
            result := true;
        end if;

        if x >= 240 and x <= 245 and y >= 130 and y <= 300 then
            result := true;
        end if;

        if x >= 300 and x <= 305 and y >= 10 and y <= 200 then
            result := true;
        end if;

        if x >= 360 and x <= 365 and y >= 150 and y <= 430 then
            result := true;
        end if;

        if x >= 420 and x <= 425 and y >= 10 and y <= 350 then
            result := true;
        end if;

        if x >= 480 and x <= 485 and y >= 110 and y <= 430 then
            result := true;
        end if;

        if x >= 540 and x <= 545 and y >= 125 and y <= 380 then
            result := true;
        end if;

        -- poziome œciany
        if y >= 60 and y <= 65 and x >= 121 and x <= 243 then
            result := true;
        end if; -- sciana 1
		  
		  if y >= 60 and y <= 65 and x >= 360 and x <= 487 then
            result := true;
        end if; -- dodatkowa sciana 1

        if y >= 120 and y <= 125 and x >= 540 and x <= 590 then
            result := true;
        end if;

        if y >= 180 and y <= 185 and x >= 10 and x <= 60 then
            result := true;
        end if;

        if y >= 240 and y <= 245 and x >= 60 and x <= 182 then
            result := true;
        end if; -- sciana 4
		  
		  if y >= 240 and y <= 245 and x >= 243 and x <= 305 then
            result := true;
        end if; -- ekstra sciana 4

        if y >= 300 and y <= 305 and x >= 180 and x <= 365 then
            result := true;
        end if;

        if y >= 360 and y <= 365 and x >= 60 and x <= 290 then
            result := true;
        end if;

        return result;
    end function;


begin

    -- Rysowanie
    process(h_count, v_count, pos_x, pos_y, goal_reached)
    begin
        if h_count < H_ACTIVE and v_count < V_ACTIVE then
            if is_wall(h_count, v_count) then
                RED <= "0"; GREEN <= "0"; BLUE <= "1";  -- niebieskie œciany
            elsif h_count >= pos_x and h_count < pos_x + BOX_WIDTH and
                  v_count >= pos_y and v_count < pos_y + BOX_HEIGHT then
                RED <= "1"; GREEN <= "0"; BLUE <= "0";  -- czerwony gracz
            elsif not goal_reached and
                  h_count >= GOAL_X and h_count < GOAL_X + BOX_WIDTH - 10 and
                  v_count >= GOAL_Y and v_count < GOAL_Y + BOX_HEIGHT - 10 then
                RED <= "0"; GREEN <= "1"; BLUE <= "0";  -- zielony cel
            else
                RED <= "1"; GREEN <= "1"; BLUE <= "1";  -- bia³e t³o
            end if;
        else
            RED <= "0"; GREEN <= "0"; BLUE <= "0";
        end if;
    end process;

    -- Ruch za pomoc¹ WSAD (klawiatura PS2)
    process(CLK)
    begin
        if rising_edge(CLK) then
            if move_counter < MOVE_DELAY then
                move_counter <= move_counter + 1;
            elsif KEY_PRESSED = '1' then
                move_counter <= 0;

                case KEY_CODE is
                    when x"1D" =>  -- W
                        if pos_y > 0 and not is_wall(pos_x, pos_y - 1) and not is_wall(pos_x + BOX_WIDTH - 1, pos_y - 1) then
                            pos_y <= pos_y - 1;
                        end if;

                    when x"1B" =>  -- S
                        if pos_y < V_ACTIVE - BOX_HEIGHT and not is_wall(pos_x, pos_y + BOX_HEIGHT) and not is_wall(pos_x + BOX_WIDTH - 1, pos_y + BOX_HEIGHT) then
                            pos_y <= pos_y + 1;
                        end if;

                    when x"1C" =>  -- A
                        if pos_x > 0 and not is_wall(pos_x - 1, pos_y) and not is_wall(pos_x - 1, pos_y + BOX_HEIGHT - 1) then
                            pos_x <= pos_x - 1;
                        end if;

                    when x"23" =>  -- D
                        if pos_x < H_ACTIVE - BOX_WIDTH and not is_wall(pos_x + BOX_WIDTH, pos_y) and not is_wall(pos_x + BOX_WIDTH, pos_y + BOX_HEIGHT - 1) then
                            pos_x <= pos_x + 1;
                        end if;

                    when others =>
                        null;
                end case;

                -- Sprawdzenie osi¹gniêcia celu
                if not goal_reached and
                   pos_x >= GOAL_X - BOX_WIDTH and pos_x <= GOAL_X + BOX_WIDTH and
                   pos_y >= GOAL_Y - BOX_HEIGHT and pos_y <= GOAL_Y + BOX_HEIGHT then
                    goal_reached <= true;
                end if;
            end if;
        end if;
    end process;

end Behavioral;