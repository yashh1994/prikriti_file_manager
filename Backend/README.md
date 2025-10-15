# Prikriti File Manager - Backend

A robust TypeScript backend API for the Prikriti File Manager application built with Node.js, Express, and MongoDB.

## 🚀 Features

- **Authentication & Authorization**: JWT-based auth with role-based access control
- **File Management**: Upload, download, organize files with folders
- **User Management**: User profiles, storage quotas, and admin controls  
- **Security**: Rate limiting, CORS, input validation, and secure file handling
- **Database**: MongoDB with Mongoose ODM
- **File Upload**: Multer with configurable storage and file type restrictions
- **Logging**: Winston logger with different log levels
- **Validation**: Joi schema validation for requests
- **Testing**: Jest testing framework setup
- **Development**: Hot reload with nodemon, ESLint, and Prettier

## 📋 Prerequisites

- Node.js (v16 or higher)
- npm or yarn
- MongoDB (local or cloud instance)

## 🛠 Installation

1. **Clone and navigate to backend directory**
   ```bash
   cd Backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment setup**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` file with your configuration:
   ```env
   NODE_ENV=development
   PORT=3000
   DATABASE_URL=mongodb://localhost:27017/prikriti_file_manager
   JWT_SECRET=your_super_secret_jwt_key_here
   # ... other configurations
   ```

4. **Create necessary directories**
   ```bash
   mkdir -p logs uploads
   ```

## 🏃‍♂️ Running the Application

### Development Mode
```bash
npm run dev
```

### Production Build
```bash
npm run build
npm start
```

### Other Scripts
```bash
# Run tests
npm test

# Run tests in watch mode  
npm run test:watch

# Lint code
npm run lint

# Fix linting issues
npm run lint:fix

# Format code
npm run format

# Clean build directory
npm run clean
```

## 📁 Project Structure

```
Backend/
├── src/
│   ├── config/          # Configuration files
│   ├── controllers/     # Route controllers
│   ├── middleware/      # Custom middleware
│   ├── models/          # MongoDB/Mongoose models
│   ├── routes/          # API routes
│   ├── services/        # Business logic services
│   ├── types/           # TypeScript type definitions
│   ├── utils/           # Utility functions
│   └── index.ts         # Application entry point
├── dist/                # Compiled JavaScript files
├── tests/               # Test files
├── uploads/             # File upload storage
├── logs/                # Application logs
├── package.json
├── tsconfig.json
└── README.md
```

## 🔗 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/logout` - User logout
- `POST /api/v1/auth/refresh-token` - Refresh JWT token
- `GET /api/v1/auth/profile` - Get user profile
- `PUT /api/v1/auth/profile` - Update user profile

### Files
- `POST /api/v1/files/upload` - Upload file
- `GET /api/v1/files` - Get user files
- `GET /api/v1/files/search` - Search files
- `GET /api/v1/files/folder/:folderId` - Get files by folder
- `GET /api/v1/files/:id` - Get specific file
- `PUT /api/v1/files/:id` - Update file metadata
- `DELETE /api/v1/files/:id` - Delete file
- `GET /api/v1/files/:id/download` - Download file

### Users (Admin only)
- `GET /api/v1/users` - Get all users
- `GET /api/v1/users/:id` - Get specific user
- `PUT /api/v1/users/:id` - Update user
- `DELETE /api/v1/users/:id` - Delete user

### Health Check
- `GET /health` - API health status

## 🔒 Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `NODE_ENV` | Environment mode | `development` |
| `PORT` | Server port | `3000` |
| `DATABASE_URL` | MongoDB connection string | `mongodb://localhost:27017/prikriti_file_manager` |
| `JWT_SECRET` | JWT signing secret | - |
| `JWT_EXPIRES_IN` | JWT expiration time | `7d` |
| `MAX_FILE_SIZE` | Maximum file size in bytes | `10485760` (10MB) |
| `ALLOWED_FILE_TYPES` | Allowed file extensions | `jpg,jpeg,png,gif,pdf,doc,docx,txt,zip` |
| `FRONTEND_URL` | Frontend URL for CORS | `http://localhost:3001` |
| `RATE_LIMIT_WINDOW` | Rate limit window in minutes | `15` |
| `RATE_LIMIT_MAX` | Max requests per window | `100` |

## 🧪 Testing

The project uses Jest for testing. Test files should be placed in the `tests/` directory or use `.test.ts` or `.spec.ts` suffix.

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Generate coverage report
npm test -- --coverage
```

## 🚀 Deployment

### Docker (Optional)
```dockerfile
# Dockerfile example
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY dist ./dist
EXPOSE 3000
CMD ["npm", "start"]
```

### PM2 (Production)
```bash
npm install -g pm2
npm run build
pm2 start dist/index.js --name "prikriti-backend"
```

## 📝 Development Guidelines

1. **Code Style**: Use ESLint and Prettier for consistent code formatting
2. **Commits**: Follow conventional commit messages
3. **Testing**: Write unit tests for new features
4. **Documentation**: Update API documentation for new endpoints
5. **Security**: Never commit sensitive data like secrets or passwords

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Run linting and tests
6. Submit a pull request

## 📄 License

This project is licensed under the ISC License.

## 🆘 Troubleshooting

### Common Issues

1. **MongoDB Connection Error**
   - Ensure MongoDB is running
   - Check DATABASE_URL in .env file
   - Verify MongoDB connection permissions

2. **File Upload Issues**
   - Check file size limits (MAX_FILE_SIZE)
   - Verify allowed file types (ALLOWED_FILE_TYPES)
   - Ensure uploads directory exists and is writable

3. **JWT Token Issues**
   - Verify JWT_SECRET is set in .env
   - Check token expiration settings
   - Ensure proper token format in requests

For more help, please open an issue in the repository.