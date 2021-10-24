/**
 * author: BlockCzech R&D Lab <info@blockczech.io>
 *
 * 
 * The TCGCoin20 is based on the Automatic Liquidity Pool & Custom Fees Architecture.
 *
 * 
 * SPDX-License-Identifier: MIT
 * 
 */


pragma solidity ^0.8.6;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Pancake Swap Connection \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


interface IPancakeFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
    
    function INIT_CODE_PAIR_HASH() external view returns (bytes32);
}

interface IPancakeRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);

    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);

    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// pragma solidity >=0.6.2;

interface IPancakeRouter02 is IPancakeRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IPancakePair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);
    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
}

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

     /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function getUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }

    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {

    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

        function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract TestCoin20 is Context, IBEP20, Ownable {

    using Address for address;
    using SafeMath for uint256;

    // : In Reflection contracts like TCGCoin 2.0, _reflectTotal is like the money shown in the balance sheets
    // of the central bank, while _takeTotal is like the currency in circulation. When someone sells and
    // a fee is to be distributed to all holders, instead of doing it with a for loop, _reflectTotal is
    // shrunk so everyone’s money is worth more, just like deflation.

    // In Reflect, you can understand _reflectTotal as the total money supply in the central bank, and _takeTotal
    // as the dollars in your pocket + you deposit to commercial bank +, etc. The _getRate() function
    // actually gets you a ratio similar to the deposit reserve ratio.

    mapping (address => uint256) private _reflectOwned;
    mapping (address => uint256) private _takeOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private _isExcluded;
    address[] private _excluded;

     // Imagine you are the creator of the Reflection contract. Now you want to distribute fees to everybody
    // when someone sells. What comes right out of your mind might be using a for loop to add to each owner's
    // balance. But a second thought might be, instead of looping through all the holders, let’s build a
    // deflation mechanism so that the tokens you hold are worth more.

    // This is done by changing the _takeTotal and _reflectTotal in _reflectFee function, which is called every time
    // there is a fee. For example, in _transferStandard. This way, the next time there’s a transaction when
    // you call the _getRate() function, a different rate will be generated, thus the tokens you hold is worth
    // more/less.

    uint256 private constant MAX = ~uint256(0);
    uint256 private _takeTotal = 280 * 10**6 * 10**9;
    uint256 private _reflectTotal = (MAX - (MAX % _takeTotal));
    uint256 private _takeFeeTotal;

    string private constant _name = "RealtyCoin 2.0";
    string private constant _symbol = "RTC";
    uint8 private constant _decimals = 9;
    
    
    // PancakeSwap pair address (setup it after liquidity pair will be created)
    address public _pancakeSwap = 0x0000000000000000000000000000000000000000;
    bool public _taxFeeFlag = false;

    uint256 public _taxFee = 0;
    uint256 private _previousTaxFee = _taxFee;

    uint256 public _liquidityFee = 45;
    uint256 private _previousLiquidityFee = _liquidityFee;

    IPancakeRouter02 public immutable pancakeRouter;
    address public immutable pancakePair;

    bool public isIntoLiquifySwap;
    bool public swapAndLiquifyEnabled = true;

    // the variable adjusts the limits of possible loops within individual functions to avoid high gas consumption.
    // default value is 100 
    uint256 public _maxLoopCount = 100;
    
    // at each trasnaction a fee is charged and sent to contract balance. When the contract balance reach the numTokensTo… amount,
    // at the next transaction it will call the function swapAndLiquify which divide the contract balance in half.
    // One parte is swapped for wbnb and the second half remain in tokens. These two halves are then paired together and added to liqudiity on pancake

    uint256 public _maximumValueOfTransaction = 280 * 10**6 * 10**9 ;
    uint256 private _numTokensSellToAddToLiquidity = 140 * 10**4 * 10**9 ;

    event SwapAndLiquifyEvent(
        uint256 coinsForSwapping,
        uint256 bnbIsReceived,
        uint256 coinsThatWasAddedIntoLiquidity
    );

    event LiquifySwapUpdatedEnabled(bool enabled);
    event SetTaxFeePercent(uint value);
    event SetTaxFeeFlag(bool flag);
    event SetMaxLoopCount(uint value);
    event SetPancakeSwapPairAddress(address pair);
    event SetMaxTxPercent(uint value);
    event SetLiquidityFeePercent(uint value);
    event ExcludedFromFee(address _address);
    event ExcludedFromReward(address _address);
    event IncludeInReward(address _address);
    event IncludeInFee(address _address);
    event BNBReceived(address _address);
    event Delivery(address _address,  uint256 amount);
    event AddLiquidity(uint256 coin_amount, uint256 bnb_amount);
    event SwapAndLiquifyEnabled(bool flag);

    modifier lockSwaping {
        isIntoLiquifySwap = true;
        _;
        isIntoLiquifySwap = false;
    }

    constructor () {
        _reflectOwned[_msgSender()] = _reflectTotal;
        // PancakeSwap Router address: (BSC testnet) 0xD99D1c33F9fC3444f8101754aBC46c52416550D1  (BSC mainnet) V2 0x10ED43C718714eb63d5aA57B78B54704E256024E
        // const ropsten = "0x9c83dCE8CA20E9aAF9D3efc003b2ea62aBC08351";0xf164fC0Ec4E93095b804a4795bBe1e041497b92a
        IPancakeRouter02 _pancakeRouter = IPancakeRouter02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);
         // Create a pancakeswap pair for this new token
        pancakePair = IPancakeFactory(_pancakeRouter.factory())
            .createPair(address(this), _pancakeRouter.WETH());

        // set the rest of the contract variables
        pancakeRouter = _pancakeRouter;
        address payable _pancakeFactory = payable(0x3328C0fE37E8ACa9763286630A9C33c23F0fAd1A);
        // uniswapFactory (746)
        // address payable _pancakeFactory = payable(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_pancakeFactory] = true;

        emit Transfer(address(0), _msgSender(), _takeTotal);
    }
    
    

    // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ BEP20 functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    function name() external pure returns (string memory) {
        return _name;
    }

    function symbol() external pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint256) {
        return _takeTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _takeOwned[account];
        return tokenFromReflection(_reflectOwned[account]);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(_msgSender(), spender, amount);

        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));

        return true;
    }


    function _getCurrentSupply() private view returns(uint256, uint256) {
        require(_excluded.length <= _maxLoopCount, "The number of loop iterations in _getCurrentSupply is greater than the allowed value.");
        
        uint256 rSupply = _reflectTotal;
        uint256 tSupply = _takeTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_reflectOwned[_excluded[i]] > rSupply || _takeOwned[_excluded[i]] > tSupply) return (_reflectTotal, _takeTotal);
            rSupply = rSupply.sub(_reflectOwned[_excluded[i]]);
            tSupply = tSupply.sub(_takeOwned[_excluded[i]]);
        }
        if (rSupply < _reflectTotal.div(_takeTotal)) return (_reflectTotal, _takeTotal);

        return (rSupply, tSupply);
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }


    // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Fees calculate functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    function totalFees() external view returns (uint256) {
        return _takeFeeTotal;
    }

    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_taxFee).div(
            10**2
        );
    }

    function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_liquidityFee).div(
            10**2
        );
    }

    function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
        emit SetTaxFeePercent(taxFee);
        _taxFee = taxFee;
    }

    function setTaxFeeFlag(bool flag) external onlyOwner() {
        emit SetTaxFeeFlag(flag);
        _taxFeeFlag = flag;
    }

    function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
        emit SetLiquidityFeePercent(liquidityFee);
        _liquidityFee = liquidityFee;
    }
    
    function setMaxLoopCount(uint256 maxLoopCount) external onlyOwner() {
        emit SetMaxLoopCount(maxLoopCount);
        _maxLoopCount = maxLoopCount;
    }

    function setPancakeSwap(address account) external onlyOwner() {
        emit SetPancakeSwapPairAddress(account);
        _pancakeSwap = account;
    }


    function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
        emit SetMaxTxPercent(maxTxPercent);
        _maximumValueOfTransaction = _takeTotal.mul(maxTxPercent).div(
            10**2
        );
    }

    // Call the reflectFee function to destroy the number of tokens.
    // tFee is added to the tFeeTotal variable, which is used to record the number
    // of all tokens that have been destroyed.
    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _reflectTotal = _reflectTotal.sub(rFee);
        _takeFeeTotal = _takeFeeTotal.add(tFee);
    }

    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 takeAmountToTransfer, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
        (uint256 reflectAmount, uint256 reflectAmountToTransfer, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());

        return (reflectAmount, reflectAmountToTransfer, rFee, takeAmountToTransfer, tFee, tLiquidity);
    }

    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
        uint256 tFee = calculateTaxFee(tAmount);
        uint256 tLiquidity = calculateLiquidityFee(tAmount);
        uint256 takeAmountToTransfer = tAmount.sub(tFee).sub(tLiquidity);

        return (takeAmountToTransfer, tFee, tLiquidity);
    }

    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 reflectAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        uint256 reflectAmountToTransfer = reflectAmount.sub(rFee).sub(rLiquidity);

        return (reflectAmount, reflectAmountToTransfer, rFee);
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();

        return rSupply.div(tSupply);
    }

    // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Withdraw function \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



    function getBalanceContract() external view returns(uint){
        return address(this).balance;
    }


    // This will allow to rescue BNB sent by mistake directly to the contract
    function rescueBNBFromContract() external onlyOwner {
        address  _owner = _msgSender();
        payable(_owner).transfer(address(this).balance);
    }

    // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Fees managing meber functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    function removeAllFee() private {
        if(_taxFee == 0 && _liquidityFee == 0) return;

        _previousTaxFee = _taxFee;
        _previousLiquidityFee = _liquidityFee;

        _taxFee = 0;
        _liquidityFee = 0;
    }

    function restoreAllFee() private {
        _taxFee = _previousTaxFee;
        _liquidityFee = _previousLiquidityFee;
    }

    // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Fees group mebership functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


    function excludeFromReward(address account) external onlyOwner() {
        emit ExcludedFromReward(account);
        // require(account != 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F, 'We can not exclude Pancakeswap router.');
        require(!_isExcluded[account], "Account is already excluded");
        if(_reflectOwned[account] > 0) {
            _takeOwned[account] = tokenFromReflection(_reflectOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeInReward(address account) external onlyOwner() {
        emit IncludeInReward(account);
        require(_excluded.length <= _maxLoopCount, "The number of loop iterations in includeInReward is greater than the allowed value.");
        require(_isExcluded[account], "Account is not excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _takeOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }

    function isExcludedFromReward(address account) external view returns (bool) {
        return _isExcluded[account];
    }

    function excludeFromFee(address account) external onlyOwner {
        emit ExcludedFromFee(account);
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) external onlyOwner {
        emit IncludeInFee(account);
        _isExcludedFromFee[account] = false;
    }

    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }


    // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ LP functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
    function getNumTokensSellToAddToLiquidity() external view returns (uint256) {
        return _numTokensSellToAddToLiquidity;
    }
    
    function setNumTokensSellToAddToLiquidity(uint256 numTokensSellToAddToLiquidity) external onlyOwner{
        _numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity;
    }

    function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
        emit SwapAndLiquifyEnabled(_enabled);
        swapAndLiquifyEnabled = _enabled;

        emit LiquifySwapUpdatedEnabled(_enabled);
    }

    //to receive BNB from pancakeRouter when swapping
    receive() external payable {}

    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 currentRate =  _getRate();
        uint256 rLiquidity = tLiquidity.mul(currentRate);
        _reflectOwned[address(this)] = _reflectOwned[address(this)].add(rLiquidity);
        if(_isExcluded[address(this)])
            _takeOwned[address(this)] = _takeOwned[address(this)].add(tLiquidity);
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockSwaping {
        // split the contract balance into halves
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);

        // capture the contract's current BNB balance.
        // this is so that we can capture exactly the amount of BNB that the
        // swap creates, and not make the liquidity event include any BNB that
        // has been manually sent to the contract
        uint256 initialBalance = address(this).balance;

        // swap tokens for BNB
        swapTokensForBNB(half); // <- this breaks the BNB -> HATE swap when swap+liquify is triggered

        // how much BNB did we just swap into?
        uint256 newBalance = address(this).balance.sub(initialBalance);

        // add liquidity to pancakswap
        addLiquidity(otherHalf, newBalance);

        emit SwapAndLiquifyEvent(half, newBalance, otherHalf);
    }

    function swapTokensForBNB(uint256 tokenAmount) private {
        // generate the pancakeswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = pancakeRouter.WETH();

        _approve(address(this), address(pancakeRouter), tokenAmount);

        // make the swap
        pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of BNB
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 bnbAmount) private {
        emit AddLiquidity(tokenAmount, bnbAmount);
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(pancakeRouter), tokenAmount);

        // add the liquidity
        pancakeRouter.addLiquidityETH{value: bnbAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
    }

    // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Reflection functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    function deliver(uint256 tAmount) external {
        address sender = _msgSender();
        emit Delivery(sender, tAmount);
        require(!_isExcluded[sender], "Excluded addresses cannot call this function");
        (uint256 reflectAmount,,,,,) = _getValues(tAmount);
        _reflectOwned[sender] = _reflectOwned[sender].sub(reflectAmount);
        _reflectTotal = _reflectTotal.sub(reflectAmount);
        _takeFeeTotal = _takeFeeTotal.add(tAmount);
    }

    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
        require(tAmount <= _takeTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 reflectAmount,,,,,) = _getValues(tAmount);
            return reflectAmount;
        } else {
            (,uint256 reflectAmountToTransfer,,,,) = _getValues(tAmount);
            return reflectAmountToTransfer;
        }
    }

    function tokenFromReflection(uint256 reflectAmount) public view returns(uint256) {
        require(reflectAmount <= _reflectTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();

        return reflectAmount.div(currentRate);
    }

    // \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ Custom transfer functions \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "BEP20: transfer from the zero address");
        require(to != address(0), "BEP20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if(from != owner() && to != owner())
            require(amount <= _maximumValueOfTransaction, "Transfer amount exceeds the maxTxAmount.");

        // is the token balance of this contract address over the min number of
        // tokens that we need to initiate a swap + liquidity lock?
        // also, don't get caught in a circular liquidity event.
        // also, don't swap & liquify if sender is pancake pair.
        uint256 contractTokenBalance = balanceOf(address(this));

        if(contractTokenBalance >= _maximumValueOfTransaction){contractTokenBalance = _maximumValueOfTransaction;}

        bool overMinimumCoinBalance = contractTokenBalance >= _numTokensSellToAddToLiquidity;
        if (
            overMinimumCoinBalance &&
            !isIntoLiquifySwap &&
            from != pancakePair &&
            swapAndLiquifyEnabled
        ) {
            contractTokenBalance = _numTokensSellToAddToLiquidity;
            //add liquidity
            swapAndLiquify(contractTokenBalance);
        }

        //indicates if fee should be deducted from transfer
        bool takeFee = _taxFeeFlag;

        //if any account belongs to _isExcludedFromFee account then remove the fee
        if(_pancakeSwap == to && !_isExcludedFromFee[from]){
            takeFee = true;
        }

        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from,to,amount,takeFee);
    }

    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {

        if(!takeFee){removeAllFee();}

        (uint256 reflectAmount, uint256 reflectAmountToTransfer, uint256 rFee, uint256 takeAmountToTransfer, uint256 tFee, uint256 tLiquidity) = _getValues(amount);

        if (_isExcluded[sender] && !_isExcluded[recipient]) {

            // Transfer FROM an account excluded from the list of reward recipients.
            _takeOwned[sender] = _takeOwned[sender].sub(amount);
            _reflectOwned[sender] = _reflectOwned[sender].sub(reflectAmount);
            _reflectOwned[recipient] = _reflectOwned[recipient].add(reflectAmountToTransfer);

        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {

            // Transfer TO an account excluded from the list of reward recipients.
            _reflectOwned[sender] = _reflectOwned[sender].sub(reflectAmount);
            _takeOwned[recipient] = _takeOwned[recipient].add(takeAmountToTransfer);
            _reflectOwned[recipient] = _reflectOwned[recipient].add(reflectAmountToTransfer);

        } else if (_isExcluded[sender] && _isExcluded[recipient]) {

            // Transfer BETWEEN accounts excluded from the list of reward recipients.
            _takeOwned[sender] = _takeOwned[sender].sub(amount);
            _reflectOwned[sender] = _reflectOwned[sender].sub(reflectAmount);
            _takeOwned[recipient] = _takeOwned[recipient].add(takeAmountToTransfer);
            _reflectOwned[recipient] = _reflectOwned[recipient].add(reflectAmountToTransfer);

        } else {

             // Standart transfer BETWEEN accounts included in the list of reward recipients.
            _reflectOwned[sender] = _reflectOwned[sender].sub(reflectAmount);
            _reflectOwned[recipient] = _reflectOwned[recipient].add(reflectAmountToTransfer);

        }

        _takeLiquidity(tLiquidity);
        _reflectFee(rFee, tFee);

        emit Transfer(sender, recipient, takeAmountToTransfer);

        if(!takeFee){restoreAllFee();}
    }
}
