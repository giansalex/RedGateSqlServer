CREATE TABLE [dbo].[TablaxMod]
(
[Cd_MR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Tab] [char] (4) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TablaxMod] ADD CONSTRAINT [PK_TablaxMod] PRIMARY KEY CLUSTERED  ([Cd_MR], [Cd_Tab]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TablaxMod] ADD CONSTRAINT [FK_TablaxMod_Modulo] FOREIGN KEY ([Cd_MR]) REFERENCES [dbo].[Modulo] ([Cd_MR])
GO
ALTER TABLE [dbo].[TablaxMod] ADD CONSTRAINT [FK_TablaxMod_Tabla] FOREIGN KEY ([Cd_Tab]) REFERENCES [dbo].[Tabla] ([Cd_Tab])
GO
