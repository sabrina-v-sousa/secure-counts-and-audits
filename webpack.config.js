const path = require('path');

module.exports = {
    mode: 'development',
    entry: './src/main/webapp/video-conferencing/video-conferencing.js',
    output: {
        filename: 'video-conferencing.bundle.js',
        path: path.resolve(__dirname, 'frontend-conferencing-build'),
    },
};