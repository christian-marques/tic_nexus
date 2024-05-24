// scripts.js
document.addEventListener("DOMContentLoaded", () => {
    const boards = document.querySelectorAll(".small-board");
    let currentPlayer = 'X';
    let nextBoard = null;
    const gameState = Array(9).fill(null).map(() => Array(9).fill(null));
    const mainBoardState = Array(9).fill(null);

    console.log("DOM");

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

        // Check for a win in the small board
        if (checkWin(gameState[boardIndex], currentPlayer)) {
            mainBoardState[boardIndex] = currentPlayer;
            cell.parentElement.classList.add('finished');
        }

        // Check for a win in the main board
        if (checkWin(mainBoardState, currentPlayer)) {
            alert(`${currentPlayer} wins the game!`);
            return;
        }

        // Determine the next board
        nextBoard = mainBoardState[cellIndex] === null ? cellIndex : null;

        // Switch player
        currentPlayer = currentPlayer === 'X' ? 'O' : 'X';
        updateBoardHighlight();
    }

    function checkWin(board, player) {
        const winPatterns = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]  // Diagonals
        ];

        return winPatterns.some(pattern => pattern.every(index => board[index] === player));
    }

    function updateBoardHighlight() {
        boards.forEach((board, index) => {
            if (nextBoard === null || nextBoard === index) {
                board.classList.add('highlight');
            } else {
                board.classList.remove('highlight');
            }
        });
    }

    boards.forEach(board => {
        for (let i = 0; i < 9; i++) {
            const cell = document.createElement('div');
            cell.addEventListener('click', handleCellClick);
            board.appendChild(cell);
        }
    });

    updateBoardHighlight();
});
