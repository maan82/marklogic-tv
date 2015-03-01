package com.marklogic.admin.controller;

import com.marklogic.admin.common.IdGenerator;
import com.marklogic.admin.common.ProgrammeParser;
import com.marklogic.admin.model.Programme;
import com.marklogic.admin.model.ProgrammeWrapper;
import com.marklogic.app.controller.ImageController;
import com.marklogic.app.controller.MediaAssetController;
import com.marklogic.repository.AssetRepository;
import com.marklogic.repository.MarkLogicRepository;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InOrder;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

import static org.hamcrest.core.Is.is;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.fail;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class ProgrammeControllerTest {

    @Mock
    private MarkLogicRepository repository;

    @Mock
    private IdGenerator idGenerator;

    @Mock
    private AssetRepository assetRepository;

    @Mock
    private ProgrammeParser programmeParser;

    @InjectMocks
    private ProgrammeController programmeController;

    @Test
    public void testAddShouldGenerateId() throws Exception {
        HttpServletRequest request = mock(HttpServletRequest.class);
        ProgrammeWrapper programmeWrapper = mock(ProgrammeWrapper.class);
        String programme = "programme";
        String replacedProgramme = "replaced_programme";
        String expected = "expected";
        String someId = "SOME_ID";

        when(idGenerator.getUUID()).thenReturn(someId);
        when(programmeWrapper.getProgramme()).thenReturn(mock(Programme.class));
        when(programmeParser.convert(programme)).thenReturn(programmeWrapper);
        when(programmeParser.convert(programmeWrapper)).thenReturn(replacedProgramme);
        when(repository.post(request, replacedProgramme, someId)).thenReturn(expected);

        String result = programmeController.add(new MultipartFile[]{}, programme, request);

        assertThat(result, is(expected));
    }

    @Test
    public void testAddShouldSaveImage() throws IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        MultipartFile multipartFile = mock(MultipartFile.class);
        ProgrammeWrapper mockProgrammeWrapper = mock(ProgrammeWrapper.class);
        Programme mockProgramme = mock(Programme.class);
        String programme = "programme";
        String expected = "expected";
        String replacedProgramme = "replaced_programme";
        String someId = "SOME_ID";
        String imagesDirectory = "/images/dir/";
        String fileName = "FileName.jpg";

        when(idGenerator.getUUID()).thenReturn(someId);
        when(mockProgrammeWrapper.getProgramme()).thenReturn(mockProgramme);
        when(programmeParser.convert(programme)).thenReturn(mockProgrammeWrapper);
        when(programmeParser.convert(mockProgrammeWrapper)).thenReturn(replacedProgramme);
        when(multipartFile.isEmpty()).thenReturn(false);
        when(multipartFile.getBytes()).thenReturn("content".getBytes());
        when(multipartFile.getContentType()).thenReturn("Image");
        when(multipartFile.getOriginalFilename()).thenReturn(fileName);
        when(repository.post(request, replacedProgramme, someId)).thenReturn(expected);
        programmeController.setImagesDirectory(imagesDirectory);

        String result = programmeController.add(new MultipartFile[]{multipartFile}, programme, request);

        InOrder inOrder = inOrder(mockProgrammeWrapper, mockProgramme, assetRepository, repository);
        inOrder.verify(mockProgrammeWrapper).getProgramme();
        inOrder.verify(mockProgramme).setImage(ImageController.RESOURCE_PATH + "/" + someId + fileName);
        inOrder.verify(assetRepository).save(multipartFile, imagesDirectory, someId + fileName);
        inOrder.verify(repository).post(request, replacedProgramme, someId);

        assertThat(result, is(expected));
    }

    @Test
    public void testAddShouldSaveMedia() throws IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        MultipartFile multipartFile = mock(MultipartFile.class);
        ProgrammeWrapper mockProgrammeWrapper = mock(ProgrammeWrapper.class);
        Programme mockProgramme = mock(Programme.class);
        String programme = "programme";
        String expected = "expected";
        String replacedProgramme = "replaced_programme";
        String someId = "SOME_ID";
        String videoDirectory = "/video/dir/";
        String fileName = "FileName.mp4";

        when(idGenerator.getUUID()).thenReturn(someId);
        when(mockProgrammeWrapper.getProgramme()).thenReturn(mockProgramme);
        when(programmeParser.convert(programme)).thenReturn(mockProgrammeWrapper);
        when(programmeParser.convert(mockProgrammeWrapper)).thenReturn(replacedProgramme);
        when(multipartFile.isEmpty()).thenReturn(false);
        when(multipartFile.getBytes()).thenReturn("content".getBytes());
        when(multipartFile.getContentType()).thenReturn("Video");
        when(multipartFile.getOriginalFilename()).thenReturn(fileName);
        when(repository.post(request, replacedProgramme, someId)).thenReturn(expected);
        programmeController.setVideosDirectory(videoDirectory);

        String result = programmeController.add(new MultipartFile[]{multipartFile}, programme, request);

        InOrder inOrder = inOrder(mockProgrammeWrapper, mockProgramme, assetRepository, repository);
        inOrder.verify(mockProgrammeWrapper).getProgramme();
        inOrder.verify(mockProgramme).setMedia(MediaAssetController.RESOURCE_PATH + "/" + someId + fileName);
        inOrder.verify(assetRepository).save(multipartFile, videoDirectory, someId + fileName);
        inOrder.verify(repository).post(request, replacedProgramme, someId);

        assertThat(result, is(expected));
    }

    @Test
    public void testAddShouldThrowRuntimeExceptionWhenAssetSaveThrowsException() throws IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        MultipartFile multipartFile = mock(MultipartFile.class);
        String expected = "expected";
        String someId = "SOME_ID";
        String videoDirectory = "/media/dir/";
        String fileName = "FileName.mp4";
        Exception toBeThrown = mock(IOException.class);

        when(idGenerator.getUUID()).thenReturn(someId);
        when(multipartFile.isEmpty()).thenReturn(false);
        when(multipartFile.getBytes()).thenReturn("content".getBytes());
        when(multipartFile.getContentType()).thenReturn("Video");
        when(multipartFile.getOriginalFilename()).thenReturn(fileName);
        when(repository.post(request, "programme", someId)).thenReturn(expected);
        doThrow(toBeThrown).when(assetRepository).save(any(MultipartFile.class), anyString(), anyString());
        programmeController.setVideosDirectory(videoDirectory);

        try {
            programmeController.add(new MultipartFile[]{multipartFile}, "programme", request);
            fail();
        } catch (RuntimeException e) {
        }
    }

}
