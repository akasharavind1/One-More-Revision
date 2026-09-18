package com.example.interviewtracker.config;

import com.example.interviewtracker.entity.User;
import com.example.interviewtracker.repository.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.support.TransactionTemplate;

@Configuration
public class DataInitializer {

    @Bean
    CommandLineRunner seed(
            @Value("${app.data.wipe-except-users:false}") boolean wipeExceptUsers,
            UserRepository users,
            CategoryRepository cats,
            SubcategoryRepository subs,
            QuestionRepository questions,
            WorkspaceNoteRepository notes,
            PasswordEncoder enc,
            TransactionTemplate transactionTemplate) {
        return args -> transactionTemplate.executeWithoutResult(status -> {
            if (wipeExceptUsers) {
                notes.deleteAll();
                questions.deleteAll();
                subs.deleteAll();
                cats.deleteAll();
            }

            if (users.count() == 0) {
                var u = new User();
                u.setEmail("admin@example.com");
                u.setDisplayName("Admin User");
                u.setPasswordHash(enc.encode("ChangeMe123!"));
                users.save(u);
            }
        });
    }
}
