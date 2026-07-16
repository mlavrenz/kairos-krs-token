// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Kairos Token (KRS)
/// @notice Fixed-supply ERC-20 on Polygon. Every transfer funds mission wallets.
/// @dev 4% fee on every transfer: 2% Mission, 1% Staking, 1% Treasury

contract KairosToken is ERC20 {
    address public constant MISSION_WALLET  = 0x429f1a7398D8CC273D513B585f9d297cf277caD8;
    address public constant STAKING_WALLET  = 0xE1e2873B60d34BbA491795341790f29687928b1d;
    address public constant TREASURY_WALLET = 0xc9D4aefE69985e1a38cb9F20EB73841CB5CC4a03;

    uint256 public constant TOTAL_SUPPLY = 100_000_000 * 10**18;

    constructor() ERC20("Kairos", "KRS") {
        _mint(msg.sender, TOTAL_SUPPLY);
    }

    function _update(
        address from,
        address to,
        uint256 amount
    ) internal override {
        if (from == address(0) || to == address(0)) {
            super._update(from, to, amount);
            return;
        }

        uint256 missionFee  = (amount * 2) / 100;  // 2%
        uint256 stakingFee  = (amount * 1) / 100;  // 1%
        uint256 treasuryFee = (amount * 1) / 100;  // 1%
        uint256 totalFee    = missionFee + stakingFee + treasuryFee;
        uint256 sendAmount  = amount - totalFee;

        super._update(from, MISSION_WALLET,  missionFee);
        super._update(from, STAKING_WALLET,  stakingFee);
        super._update(from, TREASURY_WALLET, treasuryFee);
        super._update(from, to,              sendAmount);
    }
}
