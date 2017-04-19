CREATE TABLE [dbo].[ProductoxLote]
(
[Id_ProductoxLote] [int] NOT NULL IDENTITY(1, 1),
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[RegCtbInv] [nvarchar] (15) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Lote] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [nchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cant] [numeric] (13, 3) NOT NULL,
[Ejer] [nvarchar] (4) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProductoxLote] ADD CONSTRAINT [PK_ProductoxLote_1] PRIMARY KEY CLUSTERED  ([Id_ProductoxLote]) ON [PRIMARY]
GO
