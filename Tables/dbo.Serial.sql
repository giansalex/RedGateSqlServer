CREATE TABLE [dbo].[Serial]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Serial] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Lote] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_AlmAct] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[FecIng] [datetime] NULL,
[FecSal] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Serial] ADD CONSTRAINT [PK_Seriales] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Prod], [Serial]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Serial] WITH NOCHECK ADD CONSTRAINT [FK_Serial_Producto2] FOREIGN KEY ([RucE], [Cd_Prod]) REFERENCES [dbo].[Producto2] ([RucE], [Cd_Prod])
GO
