CREATE TABLE [dbo].[DocMovAuts]
(
[Cd_DMA] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocMovAuts] ADD CONSTRAINT [PK_DocMovAuts] PRIMARY KEY CLUSTERED  ([Cd_DMA]) ON [PRIMARY]
GO
