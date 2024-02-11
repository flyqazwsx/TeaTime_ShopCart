IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Categories] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(30) NOT NULL,
    [DisplayOrder] int NOT NULL,
    CONSTRAINT [PK_Categories] PRIMARY KEY ([Id])
);
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'DisplayOrder', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
    SET IDENTITY_INSERT [Categories] ON;
INSERT INTO [Categories] ([Id], [DisplayOrder], [Name])
VALUES (1, 1, N'果汁'),
(2, 2, N'茶'),
(3, 3, N'咖啡');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'DisplayOrder', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
    SET IDENTITY_INSERT [Categories] OFF;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240120130510_TeaTime', N'8.0.1');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Products] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NOT NULL,
    [Size] nvarchar(max) NOT NULL,
    [Price] float NOT NULL,
    [Description] nvarchar(max) NOT NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY ([Id])
);
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Description', N'Name', N'Price', N'Size') AND [object_id] = OBJECT_ID(N'[Products]'))
    SET IDENTITY_INSERT [Products] ON;
INSERT INTO [Products] ([Id], [Description], [Name], [Price], [Size])
VALUES (1, N'天然果飲，迷人多變。', N'台灣水果茶', 60.0E0, N'大杯'),
(2, N' 品鐵觀音，享人生的味道。', N'鐵觀音', 35.0E0, N'中杯'),
(3, N'用咖啡體悟悠閒時光。', N'冰美式咖啡', 50.0E0, N'中杯');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Description', N'Name', N'Price', N'Size') AND [object_id] = OBJECT_ID(N'[Products]'))
    SET IDENTITY_INSERT [Products] OFF;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240121075657_addProductsToDb', N'8.0.1');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Products] ADD [CategoryId] int NOT NULL DEFAULT 0;
GO

UPDATE [Products] SET [CategoryId] = 1
WHERE [Id] = 1;
SELECT @@ROWCOUNT;

GO

UPDATE [Products] SET [CategoryId] = 2
WHERE [Id] = 2;
SELECT @@ROWCOUNT;

GO

UPDATE [Products] SET [CategoryId] = 3
WHERE [Id] = 3;
SELECT @@ROWCOUNT;

GO

CREATE INDEX [IX_Products_CategoryId] ON [Products] ([CategoryId]);
GO

ALTER TABLE [Products] ADD CONSTRAINT [FK_Products_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id]) ON DELETE CASCADE;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240121090838_addForeignKeyForCategoryProductRelation', N'8.0.1');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [Products] ADD [ImageUrl] nvarchar(max) NOT NULL DEFAULT N'';
GO

UPDATE [Products] SET [ImageUrl] = N''
WHERE [Id] = 1;
SELECT @@ROWCOUNT;

GO

UPDATE [Products] SET [ImageUrl] = N''
WHERE [Id] = 2;
SELECT @@ROWCOUNT;

GO

UPDATE [Products] SET [ImageUrl] = N''
WHERE [Id] = 3;
SELECT @@ROWCOUNT;

GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240121092004_addImageUrlToProduct', N'8.0.1');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240122135054_PC_Replacement', N'8.0.1');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [AspNetUsers] ADD [Address] nvarchar(max) NULL;
GO

ALTER TABLE [AspNetUsers] ADD [Discriminator] nvarchar(21) NOT NULL DEFAULT N'';
GO

ALTER TABLE [AspNetUsers] ADD [Name] nvarchar(max) NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240125145905_EXtendIdentityUser', N'8.0.1');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DECLARE @var0 sysname;
SELECT @var0 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AspNetUserTokens]') AND [c].[name] = N'Name');
IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [AspNetUserTokens] DROP CONSTRAINT [' + @var0 + '];');
ALTER TABLE [AspNetUserTokens] ALTER COLUMN [Name] nvarchar(450) NOT NULL;
GO

DECLARE @var1 sysname;
SELECT @var1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AspNetUserTokens]') AND [c].[name] = N'LoginProvider');
IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [AspNetUserTokens] DROP CONSTRAINT [' + @var1 + '];');
ALTER TABLE [AspNetUserTokens] ALTER COLUMN [LoginProvider] nvarchar(450) NOT NULL;
GO

DECLARE @var2 sysname;
SELECT @var2 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AspNetUserLogins]') AND [c].[name] = N'ProviderKey');
IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [AspNetUserLogins] DROP CONSTRAINT [' + @var2 + '];');
ALTER TABLE [AspNetUserLogins] ALTER COLUMN [ProviderKey] nvarchar(450) NOT NULL;
GO

DECLARE @var3 sysname;
SELECT @var3 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'[AspNetUserLogins]') AND [c].[name] = N'LoginProvider');
IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [AspNetUserLogins] DROP CONSTRAINT [' + @var3 + '];');
ALTER TABLE [AspNetUserLogins] ALTER COLUMN [LoginProvider] nvarchar(450) NOT NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240204130316_UpdateNameToBeStringApplicationUser', N'8.0.1');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Stores] (
    [Id] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NOT NULL,
    [Address] nvarchar(max) NULL,
    [City] nvarchar(max) NULL,
    [PhoneNumber] nvarchar(max) NULL,
    [Description] nvarchar(max) NULL,
    CONSTRAINT [PK_Stores] PRIMARY KEY ([Id])
);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240206142459_addStoreTable', N'8.0.1');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Address', N'City', N'Description', N'Name', N'PhoneNumber') AND [object_id] = OBJECT_ID(N'[Stores]'))
    SET IDENTITY_INSERT [Stores] ON;
INSERT INTO [Stores] ([Id], [Address], [City], [Description], [Name], [PhoneNumber])
VALUES (1, N'台中市北區三民路三段129號', N'台中市', N'鄰近台中一中商圈，學生消暑勝地。', N'台中一中店', N'0987654321'),
(2, N'台北市大安區大安路一段11號', N'台北市', N'濃厚的教育文化及熱鬧繁華的商圈，豐富整體氛圍。', N'台北大安店', N'0911111111'),
(3, N'台南市安平區安平路22號', N'台南市', N'歷史造就了現今的安平，茶香中蘊含了悠遠的歷史。', N'台南安平店', N'0922222222');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Address', N'City', N'Description', N'Name', N'PhoneNumber') AND [object_id] = OBJECT_ID(N'[Stores]'))
    SET IDENTITY_INSERT [Stores] OFF;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240206142701_addStoreRecords', N'8.0.1');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [AspNetUsers] ADD [StoreId] int NULL;
GO

CREATE INDEX [IX_AspNetUsers_StoreId] ON [AspNetUsers] ([StoreId]);
GO

ALTER TABLE [AspNetUsers] ADD CONSTRAINT [FK_AspNetUsers_Stores_StoreId] FOREIGN KEY ([StoreId]) REFERENCES [Stores] ([Id]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240208115249_addStoreToUser', N'8.0.1');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [ShoppingCarts] (
    [Id] int NOT NULL IDENTITY,
    [ProductId] int NOT NULL,
    [Count] int NOT NULL,
    [Ice] nvarchar(max) NOT NULL,
    [Sweetness] nvarchar(max) NOT NULL,
    [ApplicationUserId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_ShoppingCarts] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ShoppingCarts_AspNetUsers_ApplicationUserId] FOREIGN KEY ([ApplicationUserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_ShoppingCarts_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_ShoppingCarts_ApplicationUserId] ON [ShoppingCarts] ([ApplicationUserId]);
GO

CREATE INDEX [IX_ShoppingCarts_ProductId] ON [ShoppingCarts] ([ProductId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240208123713_addShoppingCartToDb', N'8.0.1');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240209094828_Computer_Switching', N'8.0.1');
GO

COMMIT;
GO

