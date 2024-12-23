# Service Pro

Service Pro is a comprehensive job service platform consisting of two mobile applications and a backend API. The platform allows users to request jobs and providers to manage and complete them efficiently.

---

## Overview

### Mobile Applications
1. **Service Pro Provider**
   - Repository: [Service Pro Provider](https://github.com/0Ankit0/Service_pro/tree/main/Service_Pro_Provider)
   - Built with Flutter.
   - Allows providers to:
     - List jobs.
     - Accept or reject job requests.

2. **Service Pro User**
   - Repository: [Service Pro User](https://github.com/0Ankit0/Service_pro/tree/main/Service_Pro_User)
   - Built with Flutter.
   - Enables users to:
     - Send job requests to providers.
     - Rate providers after job completion.

### API
- Repository: [API](https://github.com/0Ankit0/Service_pro/tree/main/Api)
- Built with Node.js and Express.
- Utilizes MongoDB as the database.
- Key Features:
  - **JWT Authentication**: Secures API endpoints.
  - **Mailgun Integration**: Sends emails for notifications.
  - **Image Uploads**: Stores uploaded images in the `uploads` folder.
  - **PM2 Hosting**: Hosts the API as a background service, ensuring continuous operation.
- Automated deployment using GitHub Actions:
  - Builds Docker images on each push.
  - Exposes the application on port `8000`.

---

## Project Structure

### Mobile Applications
- **Service_Pro_Provider**: Flutter app for providers.
- **Service_Pro_User**: Flutter app for users.

### API
#### Key Folders:
- **routes**: Contains route definitions for various API endpoints.
- **models**: Defines MongoDB schemas.
- **controllers**: Houses the business logic for the API.
- **middlewares**: Includes JWT validation and other middleware.
- **uploads**: Stores images uploaded by users.

---

## API Usage

### Authentication
- Endpoints are secured using JWT.
- Include a valid JWT token in the `Authorization` header for protected routes.

### Sending Emails
- Emails are sent using Mailgun.
- Configure Mailgun credentials in the environment variables.

### Image Uploads
- Uploaded images are saved in the `uploads` directory.
- Ensure appropriate permissions for the folder.

### Hosting with PM2
- PM2 is used to run the API as a background service.
- Start the API with PM2:
  ```bash
  pm2 start app.js --name service_pro_api
  ```
- Monitor the service:
  ```bash
  pm2 logs service_pro_api
  ```
- Restart the service if needed:
  ```bash
  pm2 restart service_pro_api
  ```

### Deployment
- GitHub Actions is used for CI/CD.
- Dockerized application exposes port `8000` for running the API.

---

## Getting Started

### Prerequisites
- Flutter SDK for mobile applications.
- Node.js and npm for the API.
- Docker for deployment.
- PM2 for background service hosting.
- MongoDB for the database.
- Mailgun account for email services.

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/0Ankit0/Service_pro.git
   ```
2. Navigate to the respective directories:
   - **Service_Pro_Provider** and **Service_Pro_User**: Run `flutter pub get`.
   - **API**: Run `npm install`.
3. Set up environment variables for the API:
   - JWT secret.
   - Mailgun API key and domain.
   - MongoDB connection string.

### Running the Projects
- **Mobile Applications**: Use Flutter commands to run the apps on simulators or physical devices.
- **API**:
  - Run locally: `node app.js`.
  - Run via PM2: `pm2 start app.js --name service_pro_api`.
  - Run via Docker: Build and run the Docker image.

---

## License
This project is licensed under the [MIT License](LICENSE).

---

## Contributions
Contributions are welcome! Please submit a pull request or open an issue for any suggestions or bug reports.


