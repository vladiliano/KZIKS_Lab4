library IEEE;
use IEEE.std_logic_1164.all;

entity hw_simple_aes_tb is
end entity;

architecture hw_simple_aes_tb_arch of hw_simple_aes_tb is
    signal input_msg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal cipher_key : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal cipher_mode : STD_LOGIC := '0';
	signal output_msg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	-- additional signals
	signal enc_res : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal dec_res : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin 

    UUT: entity work.hw_simple_aes(hw_simple_aes_arch)
    port map (
		INDB => input_msg,
		KEY => cipher_key,
        MODE => cipher_mode,
		OUDB => output_msg
    );
    
    stim_gen: process
	begin
		-- test 1 - part 1: encrypt
		input_msg <= "1110110000110001"; 		--EC31
		cipher_key <= "0100000000001000";		--4008
		cipher_mode <= '0'; -- encrypt
		wait for 10 ns;
		assert output_msg = "0111110010101011"	--7CAB 
		report "Test 1: Enc Open Text do not match!" 
		severity ERROR;
		
		-- test 1 - part 2: decrypt
		input_msg <= "0111110010101011"; 		--7CAB
		cipher_key <= "0100000000001000";		--4008
		cipher_mode <= '1'; -- decrypt
		wait for 10 ns;
		assert output_msg = "1110110000110001"	--EC31 
		report "Test 1: Dec Close Text do not match!" 
		severity ERROR;
		
		-- test 2 - part 1: decrypt
		input_msg <= "1001001001011010";		--925A
		cipher_key <= "0100000000001000";		--4008
		cipher_mode <= '1'; -- decrypt
		wait for 10 ns;
		assert output_msg = "1000111111001111"	--8FCF 
		report "Test 2: Dec Close Text do not match!" 
		severity ERROR;
		
		-- test 2 - part 2: encrypt
		input_msg <= "1000111111001111"; 		--8FCF
		cipher_key <= "0100000000001000";		--4008
		cipher_mode <= '0'; -- encrypt
		wait for 10 ns;
		assert output_msg = "1001001001011010"	--925A 
		report "Test 2: Enc Open Text do not match!" 
		severity ERROR;
		
		
		
		-- test 3 - part 1: encrypt
		input_msg <= "0110100000001010"; 		--680A
		cipher_key <= "1110001101100000";		--E360
		cipher_mode <= '0'; -- encrypt
		wait for 10 ns;
		assert output_msg = "1101011010001011"	--D68B 
		report "Test 3: Enc Open Text do not match!" 
		severity ERROR;
		
		-- test 3 - part 2: decrypt
		input_msg <= "1101011010001011"; 		--D68B
		cipher_key <= "1110001101100000";		--E360
		cipher_mode <= '1'; -- decrypt
		wait for 10 ns;
		assert output_msg = "0110100000001010"	--680A 
		report "Test 3: Dec Close Text do not match!" 
		severity ERROR;
		
		-- test 4 - part 1: decrypt
		input_msg <= "1101111010111011";		--DEBB
		cipher_key <= "1110001101100000";		--E360
		cipher_mode <= '1'; -- decrypt
		wait for 10 ns;
		assert output_msg = "0110000010011010"	--609A 
		report "Test 4: Dec Close Text do not match!" 
		severity ERROR;
		
		-- test 4 - part 2: encrypt
		input_msg <= "0110000010011010"; 		--609A
		cipher_key <= "1110001101100000";		--E360
		cipher_mode <= '0'; -- encrypt
		wait for 10 ns;
		assert output_msg = "1101111010111011"	--DEBB 
		report "Test 4: Enc Open Text do not match!" 
		severity ERROR;
		
	end process;

end architecture;