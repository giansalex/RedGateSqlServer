CREATE TABLE [dbo].[MtvoIngSal]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_MIS] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (150) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TM] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[Tutorial] [text] COLLATE Modern_Spanish_CI_AS NULL,
[IC_Tipo] [char] (1) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[MtvoIngSal] ADD CONSTRAINT [PK_MtvoIngSal] PRIMARY KEY CLUSTERED  ([RucE], [Cd_MIS]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MtvoIngSal] WITH NOCHECK ADD CONSTRAINT [FK_MtvoIngSal_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[MtvoIngSal] WITH NOCHECK ADD CONSTRAINT [FK_MtvoIngSal_TipoMov] FOREIGN KEY ([Cd_TM]) REFERENCES [dbo].[TipoMov] ([Cd_TM])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Mtvo Ingreso/Salida', 'SCHEMA', N'dbo', 'TABLE', N'MtvoIngSal', 'COLUMN', N'Cd_MIS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'E: Entrada, S:Salida', 'SCHEMA', N'dbo', 'TABLE', N'MtvoIngSal', 'COLUMN', N'IC_Tipo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manual de como deben ser llenados los campos para que se genere el asiento correctamente', 'SCHEMA', N'dbo', 'TABLE', N'MtvoIngSal', 'COLUMN', N'Tutorial'
GO
