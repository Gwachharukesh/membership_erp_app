"""Generate Mart ERP API Documentation as a styled PDF."""

import markdown
from weasyprint import HTML

MD_CONTENT = r"""
<div class="cover">
<h1>Mart ERP</h1>
<h2>API & Data Architecture Documentation</h2>
<p class="version">Version 1.0 &bull; March 2026</p>
<p class="subtitle">Complete Backend API Specification, Data Models, Relationships & Flow Diagrams</p>
</div>

---

# Table of Contents

1. [System Overview](#1-system-overview)
2. [Architecture Diagram](#2-architecture-diagram)
3. [Authentication Flow](#3-authentication-flow)
4. [Data Models & Relationships](#4-data-models--relationships)
5. [API Endpoints — Authentication](#5-api-endpoints--authentication)
6. [API Endpoints — User / Profile](#6-api-endpoints--user--profile)
7. [API Endpoints — Customer Registration](#7-api-endpoints--customer-registration)
8. [API Endpoints — Home / Dashboard](#8-api-endpoints--home--dashboard)
9. [API Endpoints — Product Catalog](#9-api-endpoints--product-catalog)
10. [API Endpoints — Cart & Checkout](#10-api-endpoints--cart--checkout)
11. [API Endpoints — Orders](#11-api-endpoints--orders)
12. [API Endpoints — Rewards & Points](#12-api-endpoints--rewards--points)
13. [API Endpoints — Notifications](#13-api-endpoints--notifications)
14. [User Flow Diagrams](#14-user-flow-diagrams)
15. [Error Handling Standards](#15-error-handling-standards)
16. [Appendix: Status Codes & Enums](#16-appendix-status-codes--enums)

---

# 1. System Overview

**Mart ERP** is a B2C e-commerce mobile application built with **Flutter** (frontend) communicating with a **.NET REST API** backend.

| Component       | Technology             |
|-----------------|------------------------|
| Mobile App      | Flutter 3.x / Dart     |
| State Mgmt      | BLoC (flutter_bloc)    |
| HTTP Client     | Dio                    |
| Backend API     | ASP.NET Web API        |
| Base URL        | `https://demo1.dynamicerp.online/v1/` |
| Auth Method     | Bearer Token (OAuth2 Resource Owner Password) |
| Image Caching   | CachedNetworkImage     |

### Key Features
- User authentication (login / register / OTP)
- Home dashboard (banners, categories, products, flash deals)
- Product catalog (categories, listings, detail)
- Cart & checkout
- Order management
- Reward points system (earn, redeem, tiers, leaderboard)
- Push notifications
- User profile management

---

# 2. Architecture Diagram

```
┌──────────────────────────────────────────────────────┐
│                   Flutter Mobile App                  │
│                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │  Screens  │  │  Widgets  │  │  BLoCs   │           │
│  └────┬─────┘  └──────────┘  └────┬─────┘           │
│       │                           │                  │
│       ▼                           ▼                  │
│  ┌────────────────────────────────────────┐          │
│  │          Repositories (Abstract)        │          │
│  └────────────────┬───────────────────────┘          │
│                   │                                  │
│  ┌────────────────▼───────────────────────┐          │
│  │          Repository Implementations     │          │
│  └────────────────┬───────────────────────┘          │
│                   │                                  │
│  ┌────────────────▼───────────────────────┐          │
│  │     Dio HTTP Client + Interceptors      │          │
│  │  (Auth, Retry, Chucker, Platform)       │          │
│  └────────────────┬───────────────────────┘          │
└───────────────────┼──────────────────────────────────┘
                    │ HTTPS
                    ▼
┌──────────────────────────────────────────────────────┐
│              ASP.NET Web API Backend                  │
│                                                      │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐        │
│  │   Auth     │  │  General   │  │  Customer  │        │
│  │  /token    │  │  /General/ │  │ /Customer/ │        │
│  └───────────┘  └───────────┘  └───────────┘        │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐        │
│  │  Products  │  │   Orders   │  │  Rewards   │        │
│  │ /Product/  │  │  /Order/   │  │ /Reward/   │        │
│  └───────────┘  └───────────┘  └───────────┘        │
│  ┌───────────┐  ┌───────────┐                        │
│  │   Cart     │  │  Notif.    │                        │
│  │  /Cart/    │  │ /Notif/    │                        │
│  └───────────┘  └───────────┘                        │
│                                                      │
│            ┌──────────────┐                          │
│            │   SQL Server  │                          │
│            └──────────────┘                          │
└──────────────────────────────────────────────────────┘
```

---

# 3. Authentication Flow

```
User                    App                         API Server
 │                       │                              │
 │── Enter credentials ──▶│                              │
 │                       │── POST /token ───────────────▶│
 │                       │   {userName, password,        │
 │                       │    grant_type: "password"}    │
 │                       │◀── TokenModel ───────────────│
 │                       │   {access_token, refresh_token│
 │                       │    userId, userName, ...}     │
 │                       │                              │
 │                       │── Save to SharedPreferences ──│
 │                       │                              │
 │◀── Navigate to Home ──│                              │
 │                       │                              │
 │      [On 401 Error]   │                              │
 │                       │── POST /token ───────────────▶│
 │                       │   {grant_type:"refresh_token" │
 │                       │    refresh_token, userId}     │
 │                       │◀── New TokenModel ───────────│
```

### Token Storage (SharedPreferences Keys)

| Key              | Description                     |
|------------------|---------------------------------|
| `masterToken`    | Master/admin bearer token       |
| `accessToken`    | User's bearer token             |
| `refreshToken`   | Token for refresh flow          |
| `userId`         | Logged-in user's ID             |
| `userName`       | Display name                    |
| `userType`       | Role: member, admin, systemuser |
| `customerCode`   | Customer identifier             |

---

# 4. Data Models & Relationships

## 4.1 Entity Relationship Diagram

```
┌──────────────┐      ┌──────────────────┐
│     User     │──1:N─│  Order           │
│  (userId)    │      │  (orderId)       │
└──────┬───────┘      └───────┬──────────┘
       │                      │
       │ 1:1                  │ 1:N
       ▼                      ▼
┌──────────────┐      ┌──────────────────┐
│ UserDetail   │      │  OrderItem       │
│ (profile)    │      │  (product ref)   │
└──────────────┘      └──────────────────┘
       │
       │ 1:1
       ▼
┌──────────────┐      ┌──────────────────┐
│ RewardAccount│──1:N─│ PointTransaction │
│ (points,tier)│      │ (earn/redeem)    │
└──────────────┘      └──────────────────┘

┌──────────────┐      ┌──────────────────┐
│  Category    │──1:N─│  Product         │
│ (categoryId) │      │ (productId)      │
└──────────────┘      └──────────────────┘
                             │
                             │ N:1
                             ▼
                      ┌──────────────────┐
                      │  CartItem        │
                      │  (qty, unit)     │
                      └──────────────────┘

┌──────────────┐
│ Notification │
│ (notifId)    │
└──────────────┘

┌──────────────┐      ┌──────────────────┐
│   Banner     │      │ RedeemableReward │
│  (bannerId)  │      │ (rewardId)       │
└──────────────┘      └──────────────────┘
```

## 4.2 Model Definitions

### User / Auth Models

**TokenModel** — OAuth2 token response

| Field         | Type    | JSON Key          | Description              |
|---------------|---------|-------------------|--------------------------|
| accessToken   | String? | `access_token`    | Bearer token             |
| tokenType     | String? | `token_type`      | Usually "bearer"         |
| expiresIn     | int?    | `expires_in`      | Token TTL in seconds     |
| refreshToken  | String? | `refresh_token`   | Refresh token            |
| userName      | String? | `userName`        | Display name             |
| userId        | String? | `userId`          | User ID                  |
| customerCode  | String? | `customerCode`    | Customer code            |
| userType      | String? | `userType`        | Role (member/admin/etc)  |
| dbName        | String? | `dbName`          | Database name            |
| curDateTime   | String? | `curDateTime`     | Server datetime          |
| issued        | String? | `.issued`         | Token issue time         |
| expires       | String? | `.expires`        | Token expiry time        |

**UserDetailModel** — User profile

| Field          | Type    | JSON Key         | Description                |
|----------------|---------|------------------|----------------------------|
| userId         | int?    | `UserId`         | Primary key                |
| userName       | String? | `UserName`       | Login username             |
| name           | String? | `Name`           | Full name                  |
| emailId        | String? | `EmailId`        | Email address              |
| mobileNo       | String? | `MobileNo`       | Phone number               |
| address        | String? | `Address`        | Home address               |
| designation    | String? | `Designation`    | Job title                  |
| groupName      | String? | `GroupName`       | User group                 |
| companyName    | String? | `CompanyName`    | Company name               |
| companyAddress | String? | `CompanyAddress` | Company address            |
| photoPath      | String? | `PhotoPath`      | Profile photo URL          |
| userType       | int?    | `UserType`       | User type ID               |
| branch         | String? | `Branch`         | Branch name                |
| isSuccess      | bool?   | `IsSuccess`      | API response status        |
| responseMSG    | String? | `ResponseMSG`    | API message                |

### Product / Catalog Models

**Product (CatalogProduct)**

| Field           | Type          | Description                  |
|-----------------|---------------|------------------------------|
| id              | String        | Product UUID                 |
| name            | String        | Product name                 |
| price           | double        | Selling price                |
| originalPrice   | double?       | MRP / strikethrough price    |
| imageUrl        | String        | Primary image URL            |
| brand           | String?       | Brand name                   |
| description     | String?       | Product description          |
| rating          | double?       | Average rating (0-5)         |
| isFlashDeal     | bool          | Flash deal flag              |
| discountPercent | int?          | Discount percentage          |
| pointsEarn      | int           | Reward points on purchase    |
| categoryId      | String?       | FK to Category               |
| unitOptions     | List&lt;String&gt; | Size options (250g,500g,1kg) |
| inStock         | bool          | Availability                 |

**Category (HomeCategory)**

| Field          | Type    | Description         |
|----------------|---------|---------------------|
| id             | String  | Category UUID       |
| name           | String  | Display name        |
| iconCodePoint  | int     | Material icon code  |
| imageUrl       | String? | Category image URL  |

### Order Models

**Order**

| Field          | Type             | Description              |
|----------------|------------------|--------------------------|
| id             | String           | Order UUID               |
| orderNumber    | String           | Display order number     |
| userId         | String           | FK to User               |
| items          | List&lt;OrderItem&gt; | Line items               |
| status         | OrderStatus      | Current status           |
| totalAmount    | double           | Order total              |
| shippingAddress| Address          | Delivery address         |
| paymentMethod  | String           | Payment method           |
| placedAt       | DateTime         | Order placement time     |
| deliveredAt    | DateTime?        | Delivery time            |
| trackingUrl    | String?          | Shipment tracking link   |

**OrderItem**

| Field       | Type   | Description          |
|-------------|--------|----------------------|
| productId   | String | FK to Product        |
| productName | String | Product name         |
| quantity    | int    | Quantity ordered     |
| unit        | String | Selected unit (500g) |
| price       | double | Unit price           |
| imageUrl    | String | Product image        |

### Cart Models

**CartItem**

| Field       | Type   | Description          |
|-------------|--------|----------------------|
| productId   | String | FK to Product        |
| productName | String | Product name         |
| quantity    | int    | Quantity in cart     |
| unit        | String | Selected unit        |
| price       | double | Unit price           |
| imageUrl    | String | Product image        |

### Reward Models

**RewardAccount**

| Field      | Type       | Description             |
|------------|------------|-------------------------|
| userId     | String     | FK to User              |
| points     | int        | Current balance         |
| tier       | RewardTier | bronze/silver/gold/plat |

**PointsTransaction**

| Field          | Type            | Description            |
|----------------|-----------------|------------------------|
| id             | String          | Transaction UUID       |
| description    | String          | Activity description   |
| points         | int             | +earn / -redeem        |
| date           | DateTime        | Transaction date       |
| runningBalance | int             | Balance after txn      |
| type           | TransactionType | earn / redeem          |

**RedeemableReward**

| Field       | Type    | Description             |
|-------------|---------|-------------------------|
| id          | String  | Reward UUID             |
| name        | String  | Reward name             |
| pointCost   | int     | Points required         |
| imageUrl    | String  | Reward image            |
| description | String? | Reward description      |

**LeaderboardEntry**

| Field       | Type       | Description       |
|-------------|------------|-------------------|
| rank        | int        | Position          |
| userId      | String     | User ID           |
| displayName | String     | Name              |
| points      | int        | Total points      |
| tier        | RewardTier | Current tier      |
| avatarUrl   | String?    | Profile image     |

### Dashboard Models

**DashboardSummaryModel**

| Field              | Type    | JSON Key              | Description              |
|--------------------|---------|-----------------------|--------------------------|
| ledgerId           | int?    | `LedgerId`            | Ledger ID                |
| drPoint            | int?    | `DrPoint`             | Debit points             |
| crPoint            | int?    | `CrPoint`             | Credit points            |
| balPoint           | int?    | `BalPoint`            | Balance points           |
| lastInvoiceNo      | String? | `LastInvoiceNo`       | Last invoice number      |
| lastInvoiceAmt     | int?    | `LastInvoiceAmt`      | Last invoice amount      |
| lastInvoiceDate    | String? | `LastInvoiceDate`     | Last invoice date        |
| lastInvoiceMiti    | String? | `LastInvoiceMiti`     | Nepali date              |
| lastSalesBeforeDays| int?    | `LastSalesBeforeDays` | Days since last sale     |

### Notification Model

**NotificationModel**

| Field       | Type   | Description             |
|-------------|--------|-------------------------|
| id          | String | Notification UUID       |
| title       | String | Title                   |
| description | String | Body text               |
| imagePath   | String | Image URL               |
| isRead      | bool   | Read status             |
| createdAt   | DateTime | Creation time          |
| type        | String | order/reward/promo/system |

### Banner Model

**HomeBanner**

| Field    | Type    | Description       |
|----------|---------|-------------------|
| id       | String  | Banner UUID       |
| imageUrl | String  | Banner image URL  |
| title    | String? | Banner title      |
| link     | String? | Deep link / URL   |

---

# 5. API Endpoints — Authentication

## 5.1 Login (Get Token)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/token`                                       |
| **Content** | `application/x-www-form-urlencoded`            |
| **Auth**    | None                                           |

**Request Body:**

| Field       | Type   | Required | Description         |
|-------------|--------|----------|---------------------|
| userName    | String | Yes      | Login username       |
| password    | String | Yes      | Login password       |
| grant_type  | String | Yes      | `"password"`         |
| appVer      | String | No       | App version string   |

**Response (200 OK):**

```json
{
  "access_token": "eyJhbGci...",
  "token_type": "bearer",
  "expires_in": 86400,
  "refresh_token": "abc123...",
  "userName": "john_doe",
  "userId": "42",
  "customerCode": "CUST001",
  "userType": "member",
  "dbName": "Mart_DB",
  "curDateTime": "2026-03-19T10:00:00",
  ".issued": "Thu, 19 Mar 2026 10:00:00 GMT",
  ".expires": "Fri, 20 Mar 2026 10:00:00 GMT"
}
```

## 5.2 Refresh Token

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/token`                                       |
| **Content** | `application/x-www-form-urlencoded`            |

**Request Body:**

| Field         | Type   | Required | Description          |
|---------------|--------|----------|----------------------|
| grant_type    | String | Yes      | `"refresh_token"`    |
| refresh_token | String | Yes      | Current refresh token|
| userId        | String | Yes      | User ID              |

**Response:** Same as Login response.

## 5.3 Change Password

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/General/UpdatePwd`                           |
| **Auth**    | Bearer Token                                   |

**Request Body:**

```json
{ "oldPwd": "current_password", "newPwd": "new_password" }
```

**Response:**

```json
{ "IsSuccess": true, "ResponseMSG": "Password updated successfully" }
```

---

# 6. API Endpoints — User / Profile

## 6.1 Get User Detail

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/General/GetUserDetail`                       |
| **Auth**    | Bearer Token                                   |

**Query Parameters:**

| Param   | Type | Required | Description |
|---------|------|----------|-------------|
| userId  | int  | Yes      | User ID     |

**Response (200 OK):**

```json
{
  "UserId": 42,
  "UserName": "john_doe",
  "Name": "John Doe",
  "EmailId": "john@example.com",
  "MobileNo": "9801234567",
  "Address": "Kathmandu, Nepal",
  "Designation": "Premium Member",
  "GroupName": "Gold",
  "CompanyName": "Mart Corp",
  "CompanyAddress": "Durbar Marg",
  "PhotoPath": "https://api.example.com/photos/42.jpg",
  "UserType": 2,
  "Branch": "Main Branch",
  "IsSuccess": true,
  "ResponseMSG": "Success"
}
```

## 6.2 Update User Profile (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `PUT`                                          |
| **URL**     | `/General/UpdateUserProfile`                   |
| **Auth**    | Bearer Token                                   |

**Request Body (multipart/form-data):**

| Field     | Type   | Required | Description          |
|-----------|--------|----------|----------------------|
| userId    | int    | Yes      | User ID              |
| name      | String | No       | Full name            |
| emailId   | String | No       | Email                |
| mobileNo  | String | No       | Phone                |
| address   | String | No       | Address              |
| photo     | File   | No       | Profile photo file   |

**Response:**

```json
{ "IsSuccess": true, "ResponseMSG": "Profile updated successfully" }
```

---

# 7. API Endpoints — Customer Registration

## 7.1 Generate OTP

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/Customer/GenerateOTP`                        |
| **Auth**    | Master Bearer Token                            |

**Request Body:**

```json
{
  "EmailId": "new@example.com",
  "MobileNo": "9801234567",
  "RefId": "",
  "HashData": "<HMAC-SHA512 hash>",
  "UniqueId": "<device-uuid>"
}
```

**Response:**

```json
{
  "IsSuccess": true,
  "ResponseMsg": "OTP sent to 98012*****"
}
```

## 7.2 Verify OTP

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/Customer/IsValidOTP`                         |
| **Auth**    | Master Bearer Token                            |

**Request Body:**

```json
{
  "otp": "123456",
  "refId": "REF001",
  "uniqueId": "<device-uuid>",
  "hashData": "<HMAC-SHA512 hash>"
}
```

**Response:**

```json
{ "IsSuccess": true, "ResponseMsg": "OTP verified" }
```

## 7.3 Register Customer

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `PUT`                                          |
| **URL**     | `/Customer/Register`                           |
| **Auth**    | Master Bearer Token                            |
| **Content** | `multipart/form-data`                          |
| **Headers** | `X-Idempotency-Key: <uniqueId>`               |

**Request Body (FormData):**

| Field          | Type   | Description                              |
|----------------|--------|------------------------------------------|
| paraDataColl   | JSON   | Customer data (name, mobile, email, etc.)|
| image          | File?  | Profile photo (optional)                 |

**paraDataColl JSON:**

```json
{
  "Name": "John Doe",
  "MobileNo": "9801234567",
  "EmailId": "john@example.com",
  "PanVatNo": "123456",
  "Address": "Kathmandu",
  "Lat": "27.7172",
  "Lon": "85.3240",
  "Otp": "123456",
  "UniqueId": "<device-uuid>",
  "Image": null,
  "HashData": "<HMAC-SHA512>"
}
```

**Response:**

```json
{
  "IsSuccess": true,
  "ResponseMSG": "Customer registered successfully",
  "RId": 100
}
```

---

# 8. API Endpoints — Home / Dashboard

## 8.1 Get Dashboard Summary

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/Customer/GetSalesPoint`                      |
| **Auth**    | Bearer Token                                   |

**Request:** Empty body

**Response:**

```json
{
  "LedgerId": 42,
  "DrPoint": 500,
  "CrPoint": 200,
  "BalPoint": 300,
  "LastInvoiceNo": "INV-2026-001",
  "LastInvoiceAmt": 2500,
  "LastInvoiceDate": "2026-03-15",
  "LastInvoiceMiti": "2082-12-02",
  "LastSalesBeforeDays": 4
}
```

## 8.2 Get Home Banners (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Home/GetBanners`                             |
| **Auth**    | Bearer Token                                   |

**Response:**

```json
{
  "IsSuccess": true,
  "DataColl": [
    {
      "Id": "b1",
      "ImageUrl": "https://api.example.com/banners/1.jpg",
      "Title": "Summer Sale",
      "Link": "/category/summer"
    }
  ]
}
```

## 8.3 Get Home Categories (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Product/GetCategories`                       |
| **Auth**    | Bearer Token                                   |

**Response:**

```json
{
  "IsSuccess": true,
  "DataColl": [
    {
      "Id": "cat1",
      "Name": "Groceries",
      "IconCodePoint": 58332,
      "ImageUrl": "https://api.example.com/cat/groceries.png"
    }
  ]
}
```

## 8.4 Get Featured Products (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Product/GetFeatured`                         |
| **Auth**    | Bearer Token                                   |

**Query Parameters:**

| Param     | Type   | Description                         |
|-----------|--------|-------------------------------------|
| section   | String | `top_products` / `flash_deals` / `new_arrivals` / `recommended` |
| limit     | int    | Number of items (default: 10)       |

**Response:**

```json
{
  "IsSuccess": true,
  "DataColl": [
    {
      "Id": "p1",
      "Name": "Organic Rice 5kg",
      "Price": 750.0,
      "OriginalPrice": 1000.0,
      "ImageUrl": "https://api.example.com/products/p1.jpg",
      "Brand": "FarmFresh",
      "Rating": 4.5,
      "IsFlashDeal": true,
      "DiscountPercent": 25,
      "PointsEarn": 75,
      "CategoryId": "cat1",
      "InStock": true
    }
  ]
}
```

---

# 9. API Endpoints — Product Catalog

## 9.1 Get Products by Category (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Product/GetByCategory`                       |
| **Auth**    | Bearer Token                                   |

**Query Parameters:**

| Param      | Type   | Required | Description            |
|------------|--------|----------|------------------------|
| categoryId | String | Yes      | Category UUID          |
| page       | int    | No       | Page number (default 1)|
| pageSize   | int    | No       | Items per page (def 20)|
| sortBy     | String | No       | `price_asc`, `price_desc`, `rating`, `newest` |

**Response:**

```json
{
  "IsSuccess": true,
  "TotalCount": 45,
  "Page": 1,
  "PageSize": 20,
  "DataColl": [ /* Array of Product objects */ ]
}
```

## 9.2 Get Product Detail (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Product/GetById`                             |
| **Auth**    | Bearer Token                                   |

**Query Parameters:**

| Param     | Type   | Required | Description    |
|-----------|--------|----------|----------------|
| productId | String | Yes      | Product UUID   |

**Response:**

```json
{
  "IsSuccess": true,
  "Data": {
    "Id": "p1",
    "Name": "Organic Rice 5kg",
    "Price": 750.0,
    "OriginalPrice": 1000.0,
    "ImageUrl": "https://api.example.com/products/p1.jpg",
    "Images": [
      "https://api.example.com/products/p1_1.jpg",
      "https://api.example.com/products/p1_2.jpg"
    ],
    "Brand": "FarmFresh",
    "Description": "Premium organic basmati rice...",
    "Rating": 4.5,
    "ReviewCount": 1245,
    "IsFlashDeal": false,
    "DiscountPercent": 25,
    "PointsEarn": 75,
    "CategoryId": "cat1",
    "UnitOptions": ["500g", "1kg", "5kg"],
    "InStock": true,
    "Seller": {
      "Name": "Mart Official Store",
      "Rating": 4.5
    },
    "Highlights": [
      "100% organic certified",
      "Farm-to-table delivery"
    ]
  }
}
```

## 9.3 Search Products (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Product/Search`                              |
| **Auth**    | Bearer Token                                   |

**Query Parameters:**

| Param | Type   | Required | Description       |
|-------|--------|----------|-------------------|
| q     | String | Yes      | Search query      |
| page  | int    | No       | Page number       |

**Response:** Same structure as 9.1

---

# 10. API Endpoints — Cart & Checkout

## 10.1 Get Cart (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Cart/GetCart`                                |
| **Auth**    | Bearer Token                                   |

**Response:**

```json
{
  "IsSuccess": true,
  "Data": {
    "Items": [
      {
        "ProductId": "p1",
        "ProductName": "Organic Rice 5kg",
        "Quantity": 2,
        "Unit": "5kg",
        "Price": 750.0,
        "ImageUrl": "https://api.example.com/products/p1.jpg"
      }
    ],
    "SubTotal": 1500.0,
    "DeliveryFee": 0.0,
    "Discount": 100.0,
    "Total": 1400.0,
    "PointsEarnable": 140
  }
}
```

## 10.2 Add to Cart (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/Cart/AddItem`                                |
| **Auth**    | Bearer Token                                   |

**Request:**

```json
{
  "ProductId": "p1",
  "Quantity": 1,
  "Unit": "5kg"
}
```

**Response:**

```json
{ "IsSuccess": true, "ResponseMSG": "Added to cart", "CartCount": 3 }
```

## 10.3 Update Cart Item (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `PUT`                                          |
| **URL**     | `/Cart/UpdateItem`                             |
| **Auth**    | Bearer Token                                   |

**Request:**

```json
{ "ProductId": "p1", "Quantity": 3, "Unit": "5kg" }
```

## 10.4 Remove Cart Item (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `DELETE`                                       |
| **URL**     | `/Cart/RemoveItem`                             |
| **Auth**    | Bearer Token                                   |

**Query:** `?productId=p1`

## 10.5 Place Order (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/Order/PlaceOrder`                            |
| **Auth**    | Bearer Token                                   |

**Request:**

```json
{
  "ShippingAddress": {
    "FullName": "John Doe",
    "Phone": "9801234567",
    "Address": "Durbar Marg, Kathmandu",
    "Lat": 27.7172,
    "Lon": 85.3240
  },
  "PaymentMethod": "cod",
  "CouponCode": "SAVE10",
  "UseRewardPoints": 100
}
```

**Response:**

```json
{
  "IsSuccess": true,
  "ResponseMSG": "Order placed successfully",
  "Data": {
    "OrderId": "ORD-2026-001",
    "OrderNumber": "MRT-10042",
    "TotalAmount": 1400.0,
    "PointsEarned": 140,
    "PointsUsed": 100,
    "EstimatedDelivery": "2026-03-24"
  }
}
```

---

# 11. API Endpoints — Orders

## 11.1 Get Orders List (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Order/GetOrders`                             |
| **Auth**    | Bearer Token                                   |

**Query Parameters:**

| Param  | Type   | Description                               |
|--------|--------|-------------------------------------------|
| status | String | `all` / `pending` / `confirmed` / `shipped` / `delivered` / `cancelled` |
| page   | int    | Page number                               |

**Response:**

```json
{
  "IsSuccess": true,
  "TotalCount": 25,
  "DataColl": [
    {
      "OrderId": "ORD-001",
      "OrderNumber": "MRT-10042",
      "Status": "Delivered",
      "TotalAmount": 1400.0,
      "ItemCount": 3,
      "PlacedAt": "2026-03-15T10:30:00",
      "DeliveredAt": "2026-03-19T14:00:00",
      "Items": [
        {
          "ProductName": "Organic Rice 5kg",
          "Quantity": 2,
          "ImageUrl": "https://..."
        }
      ]
    }
  ]
}
```

## 11.2 Get Order Detail (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Order/GetOrderDetail`                        |
| **Auth**    | Bearer Token                                   |

**Query:** `?orderId=ORD-001`

**Response:**

```json
{
  "IsSuccess": true,
  "Data": {
    "OrderId": "ORD-001",
    "OrderNumber": "MRT-10042",
    "Status": "Delivered",
    "Items": [ /* Full OrderItem array */ ],
    "SubTotal": 1500.0,
    "DeliveryFee": 0.0,
    "Discount": 100.0,
    "PointsUsed": 100,
    "PointsEarned": 140,
    "TotalAmount": 1400.0,
    "ShippingAddress": { /* Address object */ },
    "PaymentMethod": "cod",
    "PlacedAt": "2026-03-15T10:30:00",
    "ConfirmedAt": "2026-03-15T11:00:00",
    "ShippedAt": "2026-03-16T09:00:00",
    "DeliveredAt": "2026-03-19T14:00:00",
    "TrackingUrl": "https://..."
  }
}
```

## 11.3 Cancel Order (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/Order/CancelOrder`                           |
| **Auth**    | Bearer Token                                   |

**Request:**

```json
{ "OrderId": "ORD-001", "Reason": "Changed my mind" }
```

---

# 12. API Endpoints — Rewards & Points

## 12.1 Get Reward Summary (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Reward/GetSummary`                           |
| **Auth**    | Bearer Token                                   |

**Response:**

```json
{
  "IsSuccess": true,
  "Data": {
    "Points": 2450,
    "Tier": "gold",
    "TierMinPoints": 5000,
    "NextTierPoints": 15000,
    "NextTierName": "Platinum"
  }
}
```

## 12.2 Get Points History (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Reward/GetHistory`                           |
| **Auth**    | Bearer Token                                   |

**Query Parameters:**

| Param | Type | Description                |
|-------|------|----------------------------|
| page  | int  | Page number                |
| days  | int  | Last N days (default: 30)  |

**Response:**

```json
{
  "IsSuccess": true,
  "DataColl": [
    {
      "Id": "txn1",
      "Description": "Purchase Order #MRT-10042",
      "Points": 140,
      "Type": "earn",
      "Date": "2026-03-15T10:30:00",
      "RunningBalance": 2450
    }
  ],
  "ChartData": [
    { "Date": "2026-03-01", "PointsEarned": 50 },
    { "Date": "2026-03-02", "PointsEarned": 0 }
  ]
}
```

## 12.3 Get Redeemable Rewards (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Reward/GetRedeemable`                        |
| **Auth**    | Bearer Token                                   |

**Response:**

```json
{
  "IsSuccess": true,
  "DataColl": [
    {
      "Id": "rwd1",
      "Name": "NPR 500 Gift Card",
      "PointCost": 1000,
      "ImageUrl": "https://...",
      "Description": "Redeemable on any purchase"
    }
  ]
}
```

## 12.4 Redeem Reward (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/Reward/Redeem`                               |
| **Auth**    | Bearer Token                                   |

**Request:**

```json
{ "RewardId": "rwd1", "PointCost": 1000 }
```

**Response:**

```json
{
  "IsSuccess": true,
  "ResponseMSG": "Redeemed successfully",
  "NewBalance": 1450
}
```

## 12.5 Get Leaderboard (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Reward/GetLeaderboard`                       |
| **Auth**    | Bearer Token                                   |

**Response:**

```json
{
  "IsSuccess": true,
  "DataColl": [
    {
      "Rank": 1,
      "UserId": "u1",
      "DisplayName": "Jane Smith",
      "Points": 12500,
      "Tier": "gold",
      "AvatarUrl": "https://..."
    }
  ]
}
```

---

# 13. API Endpoints — Notifications

## 13.1 Get Notifications (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `GET`                                          |
| **URL**     | `/Notification/GetAll`                         |
| **Auth**    | Bearer Token                                   |

**Query Parameters:**

| Param | Type | Description  |
|-------|------|--------------|
| page  | int  | Page number  |

**Response:**

```json
{
  "IsSuccess": true,
  "UnreadCount": 3,
  "DataColl": [
    {
      "Id": "n1",
      "Title": "Order Delivered",
      "Description": "Your order #MRT-10042 has been delivered",
      "ImagePath": "https://...",
      "IsRead": false,
      "CreatedAt": "2026-03-19T14:00:00",
      "Type": "order"
    }
  ]
}
```

## 13.2 Mark Notification as Read (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/Notification/MarkRead`                       |
| **Auth**    | Bearer Token                                   |

**Request:**

```json
{ "NotificationId": "n1" }
```

## 13.3 Mark All as Read (Proposed)

| Property    | Value                                          |
|-------------|------------------------------------------------|
| **Method**  | `POST`                                         |
| **URL**     | `/Notification/MarkAllRead`                    |
| **Auth**    | Bearer Token                                   |

---

# 14. User Flow Diagrams

## 14.1 App Startup Flow

```
          ┌─────────────┐
          │  App Launch  │
          └──────┬──────┘
                 ▼
      ┌────────────────────┐
      │ Check SharedPrefs  │
      │ showOnboarding?    │
      └────────┬───────────┘
               │
      ┌────────▼──────┐     Yes    ┌──────────────┐
      │ First launch? ├───────────▶│  Onboarding   │
      └────────┬──────┘            │  (3 screens)  │
               │ No                └──────┬───────┘
               ▼                          │
      ┌────────────────┐                  ▼
      │ Has valid token?│◀────────────────┘
      └───┬────────┬───┘
          │Yes     │No
          ▼        ▼
   ┌──────────┐  ┌──────────┐
   │Dashboard │  │  Sign In  │
   │  (Home)  │  │  Screen   │
   └──────────┘  └──────────┘
```

## 14.2 Registration Flow

```
  Sign In Screen         App                         API
       │                  │                            │
       │─ Tap "Create" ──▶│                            │
       │                  │─ POST /token (master) ────▶│
       │                  │◀── masterToken ───────────│
       │                  │                            │
       │◀── Add Customer ─│                            │
       │     Form         │                            │
       │                  │                            │
       │─ Fill form ─────▶│                            │
       │─ Submit ────────▶│─ POST GenerateOTP ────────▶│
       │                  │◀── OTP sent ──────────────│
       │◀── OTP Screen ──│                            │
       │                  │                            │
       │─ Enter OTP ─────▶│─ POST IsValidOTP ─────────▶│
       │                  │◀── OTP valid ─────────────│
       │                  │─ PUT Customer/Register ───▶│
       │                  │◀── Success ───────────────│
       │◀── Success ──────│                            │
       │    → Sign In     │                            │
```

## 14.3 Shopping Flow (Add to Cart → Checkout)

```
  Home Screen → Product Detail → Add to Cart → Cart Screen → Checkout
       │              │               │             │            │
       │  Browse/     │  View detail  │  Select qty │  Review    │  Place
       │  Search      │  Select unit  │  Add item   │  Edit qty  │  order
       │              │               │             │  Coupon    │
       │              │               │             │  Points    │
       │              │               │             │            │
       ▼              ▼               ▼             ▼            ▼
  ┌─────────┐  ┌────────────┐  ┌──────────┐  ┌─────────┐  ┌─────────┐
  │GET      │  │GET         │  │POST      │  │GET      │  │POST     │
  │/Product/│  │/Product/   │  │/Cart/    │  │/Cart/   │  │/Order/  │
  │Featured │  │GetById     │  │AddItem   │  │GetCart  │  │Place    │
  └─────────┘  └────────────┘  └──────────┘  └─────────┘  └─────────┘
```

## 14.4 Rewards Flow

```
  Rewards Hub
       │
       ├── View Points Balance ──── GET /Reward/GetSummary
       │
       ├── Quick Actions
       │     ├── Earn More ──── Navigate to Home (shop)
       │     ├── Redeem ─────── GET /Reward/GetRedeemable
       │     │                       │
       │     │                       ▼
       │     │                  Redeem Screen
       │     │                       │
       │     │                  POST /Reward/Redeem
       │     │
       │     ├── History ────── GET /Reward/GetHistory
       │     └── Tier Status ── Calculated from Points
       │
       └── Featured Rewards ── Horizontal list → Redeem
```

## 14.5 Order Management Flow

```
  My Orders Screen ──── GET /Order/GetOrders
       │
       ├── Filter: All | Completed | Cancelled
       │
       ├── Pull to Refresh
       │
       └── Tap Order ──── GET /Order/GetOrderDetail
              │
              ├── View timeline (Placed→Confirmed→Shipped→Delivered)
              ├── Track shipment (trackingUrl)
              └── Cancel order ──── POST /Order/CancelOrder
```

---

# 15. Error Handling Standards

## Standard API Error Response

```json
{
  "IsSuccess": false,
  "ResponseMSG": "Human-readable error message",
  "ErrorNumber": 1001
}
```

## HTTP Status Codes

| Code | Meaning              | App Behavior                      |
|------|----------------------|-----------------------------------|
| 200  | Success              | Process response normally         |
| 400  | Bad Request          | Show validation error             |
| 401  | Unauthorized         | Attempt token refresh → re-login  |
| 403  | Forbidden            | Show "Access denied"              |
| 404  | Not Found            | Show "Not found" state            |
| 409  | Conflict / Duplicate | Show duplicate error              |
| 429  | Rate Limited         | Auto-retry with backoff           |
| 500  | Server Error         | Show "Server error, try again"    |
| 503  | Service Unavailable  | Auto-retry                        |

## Client-Side Error Handling

| Error Type        | Handling                                       |
|-------------------|------------------------------------------------|
| ConnectionTimeout | "Connection timeout. Check your internet."     |
| ReceiveTimeout    | "Request timeout. Please try again."           |
| SocketException   | "Network error. Check your connection."        |
| DioException      | Parse `ResponseMSG` or show generic message    |
| Unknown           | "Unexpected error occurred"                    |

---

# 16. Appendix: Status Codes & Enums

## User Types

| Value       | ID | Description         | Route           |
|-------------|-----|---------------------|-----------------|
| systemuser  | 1   | System admin user   | Dashboard       |
| member      | 2   | Regular customer    | Dashboard       |
| admin       | 3   | Admin panel         | Dashboard       |
| unknown     | 4   | Unknown             | Sign In         |

## Order Statuses

| Status     | Description                        |
|------------|------------------------------------|
| Pending    | Order placed, awaiting confirmation|
| Confirmed  | Seller confirmed the order         |
| Shipped    | Order dispatched                   |
| Delivered  | Order delivered to customer        |
| Cancelled  | Order cancelled                    |
| Returned   | Product returned                   |

## Reward Tiers

| Tier     | Min Points | Next Tier Points | Benefits                                    |
|----------|------------|------------------|---------------------------------------------|
| Bronze   | 0          | 1,000            | 10 pts/NPR 100, Birthday +500, Daily +10    |
| Silver   | 1,000      | 5,000            | 1.2x multiplier, Free delivery > NPR 2000   |
| Gold     | 5,000      | 15,000           | 1.5x multiplier, Exclusive rewards, Priority |
| Platinum | 15,000     | 50,000           | 2x multiplier, Early access, VIP events     |

## Transaction Types

| Type   | Description          |
|--------|----------------------|
| earn   | Points earned (+)    |
| redeem | Points redeemed (-)  |

## Notification Types

| Type    | Description          |
|---------|----------------------|
| order   | Order status updates |
| reward  | Points & rewards     |
| promo   | Promotional offers   |
| system  | System notifications |

---

<div class="footer">
<p>Mart ERP — API & Data Architecture Documentation v1.0</p>
<p>Generated March 2026 | Confidential</p>
</div>
"""

CSS = """
@page {
    size: A4;
    margin: 2cm 2.2cm;
    @bottom-center {
        content: "Page " counter(page) " of " counter(pages);
        font-size: 9px;
        color: #94A3B8;
        font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
    }
}

body {
    font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
    font-size: 11px;
    line-height: 1.6;
    color: #1E293B;
}

.cover {
    text-align: center;
    padding: 120px 0 60px 0;
    page-break-after: always;
}

.cover h1 {
    font-size: 42px;
    font-weight: 800;
    color: #1A73E8;
    margin-bottom: 8px;
    letter-spacing: -0.5px;
}

.cover h2 {
    font-size: 20px;
    font-weight: 400;
    color: #475569;
    margin-top: 0;
}

.cover .version {
    font-size: 13px;
    color: #94A3B8;
    margin-top: 40px;
}

.cover .subtitle {
    font-size: 12px;
    color: #64748B;
    max-width: 400px;
    margin: 10px auto 0;
}

h1 {
    font-size: 22px;
    font-weight: 700;
    color: #0F172A;
    border-bottom: 2px solid #1A73E8;
    padding-bottom: 8px;
    margin-top: 32px;
    page-break-after: avoid;
}

h2 {
    font-size: 16px;
    font-weight: 600;
    color: #1E293B;
    margin-top: 24px;
    page-break-after: avoid;
}

h3 {
    font-size: 13px;
    font-weight: 600;
    color: #334155;
    margin-top: 18px;
    page-break-after: avoid;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin: 12px 0;
    font-size: 10px;
    page-break-inside: auto;
}

tr {
    page-break-inside: avoid;
}

th {
    background-color: #F1F5F9;
    color: #334155;
    font-weight: 600;
    text-align: left;
    padding: 8px 10px;
    border: 1px solid #E2E8F0;
}

td {
    padding: 6px 10px;
    border: 1px solid #E2E8F0;
    color: #475569;
}

tr:nth-child(even) td {
    background-color: #F8FAFC;
}

code {
    font-family: 'SF Mono', 'Fira Code', 'Courier New', monospace;
    font-size: 9.5px;
    background-color: #F1F5F9;
    padding: 1px 4px;
    border-radius: 3px;
    color: #0F172A;
}

pre {
    background-color: #1E293B;
    color: #E2E8F0;
    padding: 14px 16px;
    border-radius: 8px;
    font-size: 9px;
    line-height: 1.5;
    overflow-x: auto;
    page-break-inside: avoid;
    white-space: pre-wrap;
    word-wrap: break-word;
}

pre code {
    background: none;
    padding: 0;
    color: #E2E8F0;
    font-size: 9px;
}

hr {
    border: none;
    border-top: 1px solid #E2E8F0;
    margin: 24px 0;
}

blockquote {
    border-left: 3px solid #1A73E8;
    padding-left: 12px;
    margin-left: 0;
    color: #64748B;
    font-style: italic;
}

a {
    color: #1A73E8;
    text-decoration: none;
}

.footer {
    text-align: center;
    color: #94A3B8;
    font-size: 10px;
    margin-top: 40px;
    padding-top: 20px;
    border-top: 1px solid #E2E8F0;
}
"""

def main():
    html_body = markdown.markdown(
        MD_CONTENT,
        extensions=["tables", "fenced_code", "toc", "attr_list"],
    )

    full_html = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <title>Mart ERP — API Documentation</title>
    <style>{CSS}</style>
</head>
<body>
{html_body}
</body>
</html>"""

    output_path = "/Users/dynamictechnosoft/code/mart_erp/docs/Mart_ERP_API_Documentation.pdf"
    HTML(string=full_html).write_pdf(output_path)
    print(f"PDF generated: {output_path}")

if __name__ == "__main__":
    main()
