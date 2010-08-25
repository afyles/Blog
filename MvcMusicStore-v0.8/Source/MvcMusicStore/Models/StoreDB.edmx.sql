
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, and Azure
-- --------------------------------------------------
-- Date Created: 08/02/2010 12:42:34
-- Generated from EDMX file: C:\downloads\MvcMusicStore-v0.8\Source\MvcMusicStore\Models\StoreDB.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [MvcMusicStore];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK__Album__ArtistId__276EDEB3]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Album] DROP CONSTRAINT [FK__Album__ArtistId__276EDEB3];
GO
IF OBJECT_ID(N'[dbo].[FK__InvoiceLi__Invoi__2F10007B]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[OrderDetail] DROP CONSTRAINT [FK__InvoiceLi__Invoi__2F10007B];
GO
IF OBJECT_ID(N'[dbo].[FK_Album_Genre]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Album] DROP CONSTRAINT [FK_Album_Genre];
GO
IF OBJECT_ID(N'[dbo].[FK_Cart_Album]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[Cart] DROP CONSTRAINT [FK_Cart_Album];
GO
IF OBJECT_ID(N'[dbo].[FK_InvoiceLine_Album]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[OrderDetail] DROP CONSTRAINT [FK_InvoiceLine_Album];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[Album]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Album];
GO
IF OBJECT_ID(N'[dbo].[Artist]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Artist];
GO
IF OBJECT_ID(N'[dbo].[Cart]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Cart];
GO
IF OBJECT_ID(N'[dbo].[Genre]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Genre];
GO
IF OBJECT_ID(N'[dbo].[Order]', 'U') IS NOT NULL
    DROP TABLE [dbo].[Order];
GO
IF OBJECT_ID(N'[dbo].[OrderDetail]', 'U') IS NOT NULL
    DROP TABLE [dbo].[OrderDetail];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'Albums'
CREATE TABLE [dbo].[Albums] (
    [AlbumId] int IDENTITY(1,1) NOT NULL,
    [GenreId] int  NOT NULL,
    [ArtistId] int  NOT NULL,
    [Title] nvarchar(160)  NOT NULL,
    [Price] decimal(10,2)  NOT NULL,
    [AlbumArtUrl] nvarchar(1024)  NULL
);
GO

-- Creating table 'Artists'
CREATE TABLE [dbo].[Artists] (
    [ArtistId] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(120)  NULL
);
GO

-- Creating table 'Genres'
CREATE TABLE [dbo].[Genres] (
    [GenreId] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(120)  NULL,
    [Description] nvarchar(4000)  NULL
);
GO

-- Creating table 'Carts'
CREATE TABLE [dbo].[Carts] (
    [RecordId] int IDENTITY(1,1) NOT NULL,
    [CartId] varchar(32)  NOT NULL,
    [AlbumId] int  NOT NULL,
    [Count] int  NOT NULL,
    [DateCreated] datetime  NOT NULL
);
GO

-- Creating table 'Orders'
CREATE TABLE [dbo].[Orders] (
    [OrderId] int IDENTITY(1,1) NOT NULL,
    [OrderDate] datetime  NOT NULL,
    [Username] nvarchar(256)  NULL,
    [FirstName] nvarchar(160)  NULL,
    [LastName] nvarchar(160)  NULL,
    [Address] nvarchar(70)  NULL,
    [City] nvarchar(40)  NULL,
    [State] nvarchar(40)  NULL,
    [PostalCode] nvarchar(10)  NULL,
    [Country] nvarchar(40)  NULL,
    [Phone] nvarchar(24)  NULL,
    [Email] nvarchar(160)  NULL,
    [Total] decimal(10,2)  NOT NULL
);
GO

-- Creating table 'OrderDetails'
CREATE TABLE [dbo].[OrderDetails] (
    [OrderDetailId] int IDENTITY(1,1) NOT NULL,
    [OrderId] int  NOT NULL,
    [AlbumId] int  NOT NULL,
    [Quantity] int  NOT NULL,
    [UnitPrice] decimal(10,2)  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [AlbumId] in table 'Albums'
ALTER TABLE [dbo].[Albums]
ADD CONSTRAINT [PK_Albums]
    PRIMARY KEY CLUSTERED ([AlbumId] ASC);
GO

-- Creating primary key on [ArtistId] in table 'Artists'
ALTER TABLE [dbo].[Artists]
ADD CONSTRAINT [PK_Artists]
    PRIMARY KEY CLUSTERED ([ArtistId] ASC);
GO

-- Creating primary key on [GenreId] in table 'Genres'
ALTER TABLE [dbo].[Genres]
ADD CONSTRAINT [PK_Genres]
    PRIMARY KEY CLUSTERED ([GenreId] ASC);
GO

-- Creating primary key on [RecordId] in table 'Carts'
ALTER TABLE [dbo].[Carts]
ADD CONSTRAINT [PK_Carts]
    PRIMARY KEY CLUSTERED ([RecordId] ASC);
GO

-- Creating primary key on [OrderId] in table 'Orders'
ALTER TABLE [dbo].[Orders]
ADD CONSTRAINT [PK_Orders]
    PRIMARY KEY CLUSTERED ([OrderId] ASC);
GO

-- Creating primary key on [OrderDetailId] in table 'OrderDetails'
ALTER TABLE [dbo].[OrderDetails]
ADD CONSTRAINT [PK_OrderDetails]
    PRIMARY KEY CLUSTERED ([OrderDetailId] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [ArtistId] in table 'Albums'
ALTER TABLE [dbo].[Albums]
ADD CONSTRAINT [FK__Album__ArtistId__276EDEB3]
    FOREIGN KEY ([ArtistId])
    REFERENCES [dbo].[Artists]
        ([ArtistId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK__Album__ArtistId__276EDEB3'
CREATE INDEX [IX_FK__Album__ArtistId__276EDEB3]
ON [dbo].[Albums]
    ([ArtistId]);
GO

-- Creating foreign key on [GenreId] in table 'Albums'
ALTER TABLE [dbo].[Albums]
ADD CONSTRAINT [FK_Album_Genre]
    FOREIGN KEY ([GenreId])
    REFERENCES [dbo].[Genres]
        ([GenreId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_Album_Genre'
CREATE INDEX [IX_FK_Album_Genre]
ON [dbo].[Albums]
    ([GenreId]);
GO

-- Creating foreign key on [AlbumId] in table 'Carts'
ALTER TABLE [dbo].[Carts]
ADD CONSTRAINT [FK_Cart_Album]
    FOREIGN KEY ([AlbumId])
    REFERENCES [dbo].[Albums]
        ([AlbumId])
    ON DELETE CASCADE ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_Cart_Album'
CREATE INDEX [IX_FK_Cart_Album]
ON [dbo].[Carts]
    ([AlbumId]);
GO

-- Creating foreign key on [AlbumId] in table 'OrderDetails'
ALTER TABLE [dbo].[OrderDetails]
ADD CONSTRAINT [FK_InvoiceLine_Album]
    FOREIGN KEY ([AlbumId])
    REFERENCES [dbo].[Albums]
        ([AlbumId])
    ON DELETE CASCADE ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_InvoiceLine_Album'
CREATE INDEX [IX_FK_InvoiceLine_Album]
ON [dbo].[OrderDetails]
    ([AlbumId]);
GO

-- Creating foreign key on [OrderId] in table 'OrderDetails'
ALTER TABLE [dbo].[OrderDetails]
ADD CONSTRAINT [FK__InvoiceLi__Invoi__2F10007B]
    FOREIGN KEY ([OrderId])
    REFERENCES [dbo].[Orders]
        ([OrderId])
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK__InvoiceLi__Invoi__2F10007B'
CREATE INDEX [IX_FK__InvoiceLi__Invoi__2F10007B]
ON [dbo].[OrderDetails]
    ([OrderId]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------