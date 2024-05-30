// scripts.js
document.addEventListener("DOMContentLoaded", () => {
    const boards = document.querySelectorAll(".small-board");
    let currentPlayer = 'X';
    let nextBoard = null;
    let scoreX = 0;
    let scoreO = 0;
    const gameState = Array(9).fill(null).map(() => Array(9).fill(null));
    const mainBoardState = Array(9).fill(null);
    const winPatterns = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
        [0, 4, 8], [2, 4, 6]  // Diagonals
    ];

    function handleCellClick(event) {
        const cell = event.target;
        const boardIndex = cell.parentElement.dataset.board;
        const cellIndex = Array.from(cell.parentElement.children).indexOf(cell);

        if (gameState[boardIndex][cellIndex] !== null || mainBoardState[boardIndex] !== null) {
            return; // Cell already played or board finished
        }

        // Update the cell
        gameState[boardIndex][cellIndex] = currentPlayer;
        cell.textContent = currentPlayer;
        cell.classList.add(currentPlayer.toLowerCase());

        // Check for a win in the small board
        if (checkWin(gameState[boardIndex], currentPlayer)) {
            mainBoardState[boardIndex] = currentPlayer;
            const smallBoard = cell.parentElement;
            smallBoard.classList.add('finished', currentPlayer.toLowerCase());
            smallBoard.innerHTML = `<span class="${currentPlayer.toLowerCase()}">${currentPlayer}</span>`;
            smallBoard.querySelector('span').style.fontSize = '80px';
        }

        // Check for a win in the main board
        if (checkWin(mainBoardState, currentPlayer)) {
            highlightWinningSequence(mainBoardState, currentPlayer);
            alert(`${currentPlayer} wins the game!`);
            updateScore(currentPlayer);
            return;
        }

        // Determine the next board
        nextBoard = mainBoardState[cellIndex] === null ? cellIndex : null;

        // Switch player
        currentPlayer = currentPlayer === 'X' ? 'O' : 'X';
        updateBoardHighlight();
    }

    function checkWin(board, player) {
        return winPatterns.some(pattern => pattern.every(index => board[index] === player));
    }

    function highlightWinningSequence(board, player) {
        winPatterns.forEach(pattern => {
            if (pattern.every(index => board[index] === player)) {
                pattern.forEach(index => {
                    boards[index].classList.add('winner', player.toLowerCase());
                });
            }
        });
    }

    function updateBoardHighlight() {
        boards.forEach((board, index) => {
            if ((nextBoard === null || nextBoard === index) && (mainBoardState[index] === null)) {
                board.classList.add('highlight', currentPlayer.toLowerCase());
                board.classList.remove('disabled');
            } else {
                board.classList.remove('highlight');
                board.classList.add('disabled');
            }

            // Remover as classes de highlight do jogador anterior
            if (currentPlayer === 'X') {
                board.classList.remove('o');
            } else {
                board.classList.remove('x');
            }
        });
    }

    function updateScore(player) {
        if (player === 'X') {
            scoreX++;
            document.getElementById('scoreX').textContent = scoreX;
        } else {
            scoreO++;
            document.getElementById('scoreO').textContent = scoreO;
        }
    }

    function resetScore(){
        scoreX = 0;
        scoreO = 0;
        document.getElementById('scoreX').textContent = scoreX;
        document.getElementById('scoreO').textContent = scoreO;
    }

    function resetGame() {
        currentPlayer = 'X';
        nextBoard = null;
        gameState.forEach(board => board.fill(null));
        mainBoardState.fill(null);
        boards.forEach(board => {
            board.className = 'small-board';
            board.innerHTML = '';
            for (let i = 0; i < 9; i++) {
                const cell = document.createElement('div');
                cell.classList.add('cell');
                cell.addEventListener('click', handleCellClick);
                board.appendChild(cell);
            }
        });
        updateBoardHighlight();
    }

    document.getElementById('startGame').addEventListener('click', () => {
        resetGame();
    });

    document.getElementById('resetGame').addEventListener('click', () => {
        document.getElementById('playerX').value = '';
        document.getElementById('playerO').value = '';
        resetScore();
        resetGame();
    });

    boards.forEach(board => {
        for (let i = 0; i < 9; i++) {
            const cell = document.createElement('div');
            cell.classList.add('cell');
            cell.addEventListener('click', handleCellClick);
            board.appendChild(cell);
        }
    });

    updateBoardHighlight();
});
