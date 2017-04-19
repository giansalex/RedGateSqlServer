CREATE TABLE [dbo].[Proveedor]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Aux] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cta] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Proveedor] ADD CONSTRAINT [PK_Proveedor] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Aux]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Proveedor] WITH NOCHECK ADD CONSTRAINT [FK_Proveedor_Auxiliar] FOREIGN KEY ([RucE], [Cd_Aux]) REFERENCES [dbo].[Auxiliar] ([RucE], [Cd_Aux])
GO
